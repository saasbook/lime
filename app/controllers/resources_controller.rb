class ResourcesController < ApplicationController

  def resource_params
    params.permit(:title, :url, :contact_email, :location, :types, :audiences, :population_focuses, :campuses,
                                      :colleges, :availabilities, :innovation_stages, :topics, :technologies)
  end

  def index
    sort_by = nil
    if params.include? :sort_by
      sort_by = params[:sort_by]
      params.delete :sort_by
    end

    @resources = Resource.filter(resource_params)

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.reflect_on_all_associations(:has_many).map! { |association| association.name.to_sym } ) }
      format.html
    end
  end

  def show
    id = params[:id]
    @resource = Resource.find_by_id(id)
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