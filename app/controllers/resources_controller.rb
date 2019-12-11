class ResourcesController < ApplicationController
  require 'csv'
  include ResourcesControllerHelper
  include ResourcesControllerUpload
  def resource_params
    params.permit(
                  :title, :url, :contact_email, :location, :population_focuses, :campuses,
                  :colleges, :availabilities, :innovation_stages, :topics, :technologies,
                  :types, :audiences, :description, :approval_status, :flagged, :flagged_comment,
                  :contact_name, :contact_phone, :client_tags, :resource_email, :resource_phone,
                  :address, :deadline, :notes, :funding_amount, :approved_by, :search,

                  types: [], colleges: [], audiences: [], campuses: [], client_tags: [], innovation_stages: [],
                  population_focuses: [], availabilities: [], topics: [], technologies: []
                 )
  end

  before_action :set_user
  before_action :set_resource_owner

  def has_many_value_hash
    {
        'types' => Type.get_values,
        'audiences' => Audience.get_values,
        'campuses' => Campus.get_values,
        'client_tags' => ClientTag.get_values,
        'innovation_stages' => InnovationStage.get_values,
        'population_focuses' => PopulationFocus.get_values,
        'availabilities' => Availability.get_values,
        'topics' => Topic.get_values,
        'technologies' => Technology.get_values
    }
  end

  # GET requests that access the entire database
  # includes the filtering
  #
  # if an API call: assumes API GET request in this format :
  # GET /resources?types=Events,Mentoring&audiences=Undergraduate,Graduate&sort_by=title
  # GET /resources?title=Feminist Research Institute
  #
  # if webpage/html: grabs all resources
  def index
    reset_session
    params.each do |key, value|
      session[key] = value
    end
    @sort_by = params[:sort_by].to_s
    if @sort_by.nil? || (@sort_by != "location" && @sort_by != "title")
      @sort_by = "updated_at"
    end

    # TODO (if API GET requests available for non-admins)
    # if an Admin making API call, show all resources
    # else show only resources that have approval_status = 1

    # this functionality was meant for the web app
    # but has been removed
    #
    # if (@resources == nil || @resources.length == 0)
    #   # if no results, suggests to search again with exact same params but instead uses parent location
    #   @parent_location = Location.get_parent(params[:location])
    #   @parent_params = params
    #   @parent_params[:location] = @parent_location

    #   @parent_query = "/resources.html?" + @parent_params.except(:controller, :action, :format).to_unsafe_h.to_query
    # else
    #   @resources = @resources.order(sort_by)
    # end
    @resources = Resource.location_helper(resource_params)


    # process the data differently depending if an API call or a webpage
    respond_to do |format|
      format.json {
        @resources = @resources.order(@sort_by)

        render json: @resources
      }
      format.html {
        # no one using the web app is allowed to view unapproved
        params[:approval_status] = 1

        @has_many_hash = self.has_many_value_hash
        @filters = {}
        @has_many_hash.each do |association, values|
          @valid_associations = []
          values.each do |value|
            if association.classify.constantize.count(value) > 0
              @valid_associations.push(value)
            end
          end
          @filters[association] = @valid_associations
        end

        @has_many_hash = @filters

        @locations = Location.get_locations
        @child_locations = Hash.new

        @locations["location"].each { |value|
          children = Location.child_locations(value)
          @child_locations[value] = children
        }
        # attempt to eager load all resources
        @all_resources = Resource.where(approval_status: 1).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies)

        @resources_json = @all_resources.as_json(include: Resource.include_has_many_params)

        @resources_json.map! do |resource|
          resource = json_fix(resource)
        end
      }
    end
  end

  def show
    id = params[:id]
    @resource = Resource.find_by_id(id)
    @all_values_hash = Resource.all_values_hash
    @all_public_values_hash = Resource.all_public_values_hash
    @has_many_hash = self.has_many_value_hash

    # only admins can see unapproved and archived resources
    @resource = nil if @user.nil? && (@resource&.approval_status == 0)

    @resource = json_fix(@resource)
    @updated_at = @resource["updated_at"]
    respond_to do |format|
      format.json { render json: @resource.to_json(include: Resource.include_has_many_params) }
      format.html
    end
  end

  def new
    @has_many_hash = self.has_many_value_hash
    @locations = Location.get_locations
    @session = session
    render template: "resources/new.html.erb"
  end

  def create
    #this should check any of the params are missing via validation and set an instance variable equal to the missing fields
    #otherwise add a new object to the database
    reset_session
    @desc_too_long = false
    @missing = Resource.find_missing_params(params)

    #@missing = !((Resource.get_required_resources & params.keys).sort == Resource.get_required_resources.sort)

    if @missing.length > 0
      params.each { |key, val| session[key] = params[key] }
      # redirect_to :controller => 'resources', :action => 'new'
      return
    end
    if (params[:description] != nil) && (params[:description].length > 500) then @desc_too_long = true end
    if @desc_too_long
      params.each do |key, val|
        session[key] = params[key]
      end
      # redirect_to :controller => 'resources', :action => 'new'
      return
    end

    flash[:notice] = "Your resource has been successfully submitted and will be reviewed!"

    # https://stackoverflow.com/questions/18369592/modify-ruby-hash-in-place-rails-strong-params
    rp = resource_params
    rp[:approval_status] = 0
    rp[:flagged] = 0
    @resource = Resource.create_resource(rp)
    Location.nest_location(params[:location]) if params[:location] != nil

    respond_to do |format|
      format.json { render json: @resource.to_json(includes: Resource.include_has_many_params) }
      format.html { redirect_to controller: '/resources' }
    end
  end

  def update
    @resource = Resource.find_by(id: params[:id])
    if @resource.nil?
      flash[:notice] = "This resource does not exist"
      return
    end

    new_params = Resource.cast_param_vals(params)
    # TODO: finish/fix edit log functionality
    # Resource.log_edits(new_params)

    # Don't let guests update anything unless the params are "allowed"
    if Resource.guest_update_params_allowed?(resource_params) && @user.nil?
      # temp: update anyway
      Resource.update_resource(new_params[:id], resource_params)
    elsif @resource_owner && (@resource.contact_email == @resource_owner.email)
      Resource.update_resource(new_params[:id], resource_params)
    elsif @user.nil?
      flash[:notice] = "You don't have permissions to update records"
      redirect_to controller: 'resources', action: 'edit'
      return
    else
      Resource.update_resource(new_params[:id], resource_params)
      # send approval email to resource owner if updated approval status to 1 and if
      # the resource has a valid contact email
      if resource_params[:approval_status] == 1 && @resource.approval_status == 0
        Resource.approval_email(@resource)
      end
    end
    @resource = Resource.find(new_params[:id])

    respond_to do |format|
      format.json { render json: @resource.to_json(include: Resource.include_has_many_params) }
      format.html do
        flash[:notice] = "Resource updated."
        redirect_to controller: 'resources', action: 'edit'
      end
    end
  end

  # fixes the formatting issue that .to_json does
  # where the associations with "many_params" are converted to arrays of hashes for each ":val"
  # this helper converts the array of hashes to just an array
  def json_fix(resource)
    return nil if (resource.nil?)
    @full_resource = resource.as_json(include: Resource.include_has_many_params)
    @full_resource.each do |association, values|
      if values.kind_of?(Array) && values.length > 0
        new_association = Array.new
        values.each do |value|
          value.each do |k, v|
            new_association.push(v)
          end
        end
        @full_resource[association] = new_association
      end
    end
    return @full_resource
  end

  def edit
    if !Resource.guest_update_params_allowed?(resource_params) && @user.nil? && @resource_owner.nil?
      flash[:notice] = "You don't have permissions to update records"
      redirect_to '/resources.html'
      return
    end

    @resource = Resource.find(params[:id])
    if @resource_owner && (@resource.contact_email != @resource_owner.email) && @user.nil?
      flash[:notice] = "You don't have permissions to update this record."
      redirect_to '/resources.html'
      return
    end

    respond_to do |format|
      format.json {redirect_to "/resources/" + params[:id] + "/edit.html" }
      format.html do
        @resource = Resource.find(params[:id])
        @locations = Location.get_locations
        @session = session
        @has_many_hash = self.has_many_value_hash
      end
    end
  end

  def destroy
    Resource.destroy(params[:id])
    flash[:alert] = "Resource permanently deleted"
    redirect_back(fallback_location: root_path)
  end

  # find the resource to edit based on owner's email
  def owner_edit
    # session[:resource_owner] = false
    @resource = Resource.find_by contact_email:params[:email]
    if @resource.nil?
      flash[:notice] = "The resources you own might be under a different email, please contact us."
      redirect_to '/resources.html'
      return
    end
    if @resource_owner.nil? || (@resource.contact_email != @resource_owner.email)
      flash[:notice] = "You don't have permissions to update this record."
      redirect_to '/resources.html'
      return
    end

    params[:id] = @resource.id.to_s
    redirect_to "/resources/" + params[:id] + "/edit.html"
  end
end


