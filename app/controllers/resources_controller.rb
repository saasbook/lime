class ResourcesController < ApplicationController
  def resource_params
    params.permit(:title, :url, :contact_email, :location, :population_focuses, :campuses,
                  :colleges, :availabilities, :innovation_stages, :topics, :technologies,
                  :types, :audiences, :desc, :approval_status, :exclusive, :api_key, :flagged, :flagged_comment)
  end

  before_action :set_user

  # assumes API GET request in this format :
  # GET /resources?types=Events,Mentoring&audiences=Undergraduate,Graduate&sort_by=title
  # GET /resources?title=Feminist Research Institute
  def index
    if params.include? :sort_by
      sort_by = params[:sort_by] # fetch sort_by term
      params.delete :sort_by # remove sort_by param from params hash
    else
      sort_by = nil
    end

    @resources = Resource.location_helper(resource_params)
    if @resources != nil
       @resources = @resources.order(sort_by)
    end

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.has_many_associations) }
      format.html
    end
  end

  def show
    id = params[:id]
    @resource = Resource.find_by_id(id)

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.has_many_associations) }
      format.html
    end
  end


  def new
    render template: "resources/new.html.erb"
    # render "resources/new"
  end

  def create
    #this should check any of the params are missing via validation and set an instance variable equal to the missing fields
    #otherwise add a new object to the database
    @desc_too_long = false
    @missing = !((Resource.get_required_resources & params.keys).sort == Resource.get_required_resources.sort)
    if params[:desc] != nil and params[:desc].length > 500
      @desc_too_long = true
    end

    if @missing
      flash[:notice] = "Please fill in the required fields."
      return
    elsif @desc_too_long
      flash[:notice] = "Description was too long."
      return
    end

    flash[:notice] = "Your resource has been successfully submitted and will be reviewed!"
    #https://stackoverflow.com/questions/18369592/modify-ruby-hash-in-place-rails-strong-params
    rp = resource_params
    rp[:approval_status] = @user == nil ? 0 : 1
    @resource = Resource.create_resource(rp)

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.has_many_associations) }
      format.html
    end

  end

  def update
    # Don't let guests update anything unless the params are "allowed"
    if !Resource.guest_update_params_allowed?(resource_params) and @user == nil
      flash[:notice] = "You don't have permissions to update records"
      return
    end

    if params[:flagged]
      params[:flagged] = params[:flagged].to_i
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:flagged])
      @edit.save!
    end
    if params[:flagged_comment]
      params[:flagged_comment] = params[:flagged_comment].to_s
    end
    if params[:approval_status]
      params[:approval_status] = params[:approval_status].to_i
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:approval_status])
      @edit.save!
    end
    if params[:title]
      params[:title] = params[:title].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:title])
      @edit.save!
    end
    if params[:url]
      params[:url] = params[:flagged].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:url])
      @edit.save!
    end
    if params[:contact_email]
      params[:contact_email] = params[:contact_email].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:contact_email])
      @edit.save!
    end
    if params[:location]
      params[:location] = params[:location].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:location])
      @edit.save!
    end
    if params[:population_focuses]
      params[:population_focuses] = params[:population_focuses].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:campuses])
      @edit.save!
    end
    if params[:campuses]
      params[:campuses] = params[:campuses].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:campuses])
      @edit.save!
    end
    if params[:colleges]
      params[:colleges] = params[:colleges].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:colleges])
      @edit.save!
    end
    if params[:availabilities]
      params[:availabilities] = params[:availabilities].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter =>  params[:availabilities])
      @edit.save!
    end
    if params[:innovation_stages]
      params[:innovation_stages] = params[:innovation_stages].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:innovation_stages])
      @edit.save!
    end
    if params[:availabilities]
      params[:availabilities] = params[:availabilities].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:availabilities])
      @edit.save!
    end
    if params[:topics]
      params[:topics] = params[:topics].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:topics])
      @edit.save!
    end
    if params[:technologies]
      params[:technologies] = params[:technologies].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:technologies])
      @edit.save!
    end
    if params[:types]
      params[:types] = params[:types].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:types])
      @edit.save!
    end
    if params[:audiences]
      params[:audiences] = params[:audiences].to_s
      @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => params[:audiences])
      @edit.save!
    end

    Resource.update(params[:id], resource_params)

    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.has_many_associations) }
      format.html
    end
  end

  def edit

  end

  def destroy

  end

  def set_user
    if request.format.json? and params.include? :api_key
      @user = User.where(:api_token => params[:api_key]).first
    else
      @user = current_user
    end
    params.delete :api_key
  end

end
