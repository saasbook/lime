class ResourcesController < ApplicationController

  def resource_params
    params.require(:resources).permit(:title, :url, :contact_email, :location, :types, :audiences, :presence)
  end

  def index
    @all_resources = Resource.all
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