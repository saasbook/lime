class ResourcesController < ApplicationController
  def resource_params
    params.permit(:title, :url, :contact_email, :location, :population_focuses, :campuses,
                                      :colleges, :availabilities, :innovation_stages, :topics, :technologies, :types => [], :audiences => [])
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

    @resources = Resource.filter(resource_params)
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

  end

  def create
    #this should check if any of the params are missing via validation and set an instance variable equal to the missing fields
    #otherwise add a new object to the database 
    #redirect to a submission page
    @error = false
    #attempt to create and save resource to the database for approval
    r = Resource.new(resource_params)
    r.approval_status = 0
    
    if r.invalid?
      @error = true
      @missing = []
      @desc_too_long = false
      Resource.get_required_resources.each do |resource|
        if !params.include? resource or params[resource] == nil?
          @missing.push(resource)
        end
      end
      if !params[:desc] == nil and params[:desc].length > 500
        @desc_too_long = true
      end
    end
    r.save
  end

  def update

  end

  def edit

  end

  def destroy

  end

end