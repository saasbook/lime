class ResourcesController < ApplicationController
  def resource_params
    params.permit(:title, :url, :contact_email, :location, :population_focuses, :campuses,
                                      :colleges, :availabilities, :innovation_stages, :topics, :technologies, :desc, :types => [], :audiences => [])
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

    @resources = Resource.filter(resource_params).order(sort_by)
    if params.include? :location
      # if filtering by location
      Resource.location_helper(resource_params.to_h.map {|k,v| [k.to_sym, v]}.to_h[:location].to_s, @resources)

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
    #this should check any of the params are missing via validation and set an instance variable equal to the missing fields
    #otherwise add a new object to the database 
    #redirect to a submission page
    @missing = []
    @desc_too_long = false
    #manual validation of resources
    Resource.get_required_resources.each do |resource|
      if !params.include? resource or params[resource] == nil
        @missing.push(resource)
      end
    end
    if !params[:desc] == nil and params[:desc].length > 500
      @desc_too_long = true
    end

    if @missing.size != 0 or @desc_too_long
      return
    end
    #
    resource = Resource.create(resource_params)

    #create all associated entries
    has_many_hash = Resource.get_has_many_hashes(params)
    has_many_hash.each_key do |key|
      has_many_hash[key].each do |val|
        if key == "audiences"
          resource.audiences.create(val: val)
        end
        if key == "types"
          resource.types.create(val: val)
        end
      end
    end
    # puts "success"
  end

  def update

  end

  def edit

  end

  def destroy

  end

end