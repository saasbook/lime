class ResourcesController < ApplicationController
  def resource_params
    params.permit(:title, :url, :contact_email, :location, :population_focuses, :campuses,
                  :colleges, :availabilities, :innovation_stages, :topics, :technologies,
                  :types, :audiences, :desc, :approval_status, :exclusive, :api_key, :flagged)
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
    rp[:approval_status] = 0
    @resource = Resource.create_resource(rp)

  

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.has_many_associations) }
      format.html
    end

  end

  def update
    # Don't let guests update anything unless the params are "allowed"
    if @user == nil and !Resource.guest_update_params_allowed?(resource_params)
      flash[:notice] = "You don't have permissions to update records"
      return
    end
    if params[:flagged]
      params[:flagged] = params[:flagged].to_i
    end
    if params[:approval_status]
      params[:approval_status] = params[:approval_status].to_i
    end
    if params[:title]
      params[:title] = params[:title].to_s
    end
    if params[:url]
      params[:url] = params[:flagged].to_s
    end
    if params[:contact_email]
      params[:contact_email] = params[:contact_email].to_s
    end
    if params[:location]
      params[:location] = params[:location].to_s
    end
    if params[:population_focuses]
      params[:population_focuses] = params[:population_focuses].to_s
    end
    if params[:campuses]
      params[:campuses] = params[:campuses].to_s
    end
    if params[:colleges]
      params[:colleges] = params[:colleges].to_s
    end
    if params[:availabilities]
      params[:availabilities] = params[:availabilities].to_s
    end
    if params[:innovation_stages]
      params[:innovation_stages] = params[:innovation_stages].to_s
    end
    if params[:availabilities]
      params[:availabilities] = params[:availabilities].to_s
    end
    if params[:topics]
      params[:topics] = params[:topics].to_s
    end
    if params[:technologies]
      params[:technologies] = params[:technologies].to_s
    end
    if params[:types]
      params[:types] = params[:types].to_s
    end
    if params[:audiences]
      params[:audiences] = params[:audiences].to_s
    end

    @edit = Edit.new(:resource_id => params[:id], :user => @user, :parameter => resource_params)

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
    puts request.format.json?
    if request.format.json? and params.include? :api_key
      @user = User.where(:api_token => params[:api_key]).first
    else
      @user = current_user
    end
    params.delete :api_key
  end

end
