class ResourcesController < ApplicationController

  def resource_params
    params.permit(:title, :url, :contact_email, :location, :types, :audiences, :population_focuses, :campuses,
                                      :colleges, :availabilities, :innovation_stages, :topics, :technologies)
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

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.reflect_on_all_associations(:has_many).map! { |association| association.name.to_sym } ) }
      format.html
    end
  end

  def show
    id = params[:id]
    @resource = Resource.find_by_id(id)

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.reflect_on_all_associations(:has_many).map! { |association| association.name.to_sym } ) }
      format.html
    end
  end

  def new

  end

  def create

  end

  def update

  end

  def edit

  end

  def destroy

  end

end