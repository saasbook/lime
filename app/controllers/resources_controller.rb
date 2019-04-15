class ResourcesController < ApplicationController
  def resource_params
    params.permit(:title, :url, :contact_email, :location, :population_focuses, :campuses,
                  :colleges, :availabilities, :innovation_stages, :topics, :technologies,
                  :types, :audiences, :desc, :approval_status, :exclusive)
  end

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
    # https://stackoverflow.com/questions/18369592/modify-ruby-hash-in-place-rails-strong-params
    rp = resource_params
    rp[:approval_status] = 0
    @resource = Resource.create_resource(rp)

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.has_many_associations) }
      format.html
    end

  end

  def update
    # get the resource we want to update by its id
    id = params[:id]
    @resource = Resource.find_by_id(id)

    # change diff params

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.has_many_associations) }
      format.html
    end
  end

  def edit

  end

  def destroy

  end

end
