class ResourcesController < ApplicationController
  require 'csv'
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
    if @sort_by == nil || (@sort_by != "location" && @sort_by != "title")
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

        render :json => @resources
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

        @locations["location"].each {|value|
          children = Location.child_locations(value)
          @child_locations[value] = children
        }
        # attempt to eager load all resources
        @all_resources = Resource.where(:approval_status => 1).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies)

        @resources_json = @all_resources.as_json(:include => Resource.include_has_many_params)

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
    if @user.nil? and @resource&.approval_status == 0
      @resource = nil
    end
    
    @resource = json_fix(@resource)
    @updated_at = @resource["updated_at"]
    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.include_has_many_params) }
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
      params.each {|key, val| session[key] = params[key]}
      # redirect_to :controller => 'resources', :action => 'new'
      return
    end
    if params[:description] != nil and params[:description].length > 500 then @desc_too_long = true end
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
    if params[:location] != nil then Location.nest_location(params[:location]) end

    respond_to do |format|
      format.json {render :json => @resource.to_json(:includes => Resource.include_has_many_params) }
      format.html {redirect_to :controller => '/resources'}
    end
  end

  def update
    @resource = Resource.find_by(id: params[:id])
    if @resource == nil
      flash[:notice] = "This resource does not exist"
      return
    end
    
    new_params = Resource.cast_param_vals(params)
    # TODO: finish/fix edit log functionality
    # Resource.log_edits(new_params)

    # Don't let guests update anything unless the params are "allowed"
    if Resource.guest_update_params_allowed?(resource_params) && @user == nil
      Resource.update_resource(new_params[:id], resource_params)
    elsif @user == nil
      flash[:notice] = "You don't have permissions to update records"
      redirect_to :controller => 'resources', :action => 'edit'
      return
    else
      Resource.update_resource(new_params[:id], resource_params)
      
    end
    @resource = Resource.find(new_params[:id])

    respond_to do |format|
      format.json {render :json => @resource.to_json(:include => Resource.include_has_many_params) }
      format.html do
        flash[:notice] = "Resource updated."
        redirect_to :controller => 'resources', :action => 'edit'
      end
    end
  end

  # fixes the formatting issue that .to_json does 
  # where the associations with "many_params" are converted to arrays of hashes for each ":val"
  # this helper converts the array of hashes to just an array
  def json_fix(resource)
    if (resource == nil) 
      return nil
    end
    @full_resource = resource.as_json(:include => Resource.include_has_many_params)
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

  def upload
    uploaded_io = params[:csv]
    if uploaded_io == nil
      flash[:alert] = "Please choose a file first before uploading."
      redirect_to "/resources/unapproved.html"
      return
    end
    csv_text = uploaded_io.read
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
    count = 0
    csv.each do |row|
      record = {
        'title': row['Title'],
        'url': row['Resource URL'],
        'resource_email': row['Email-General'],
        'resource_phone': row['Phone-General'],
        'address': row['Address'],
        'contact_email': row['Email-Contact'],
        'contact_name': row['Contact'],
        'contact_phone': row['Phone-Contact'],
        'description': row['Resource Description'],
        'types': row['Resource Type'],
        'audiences': row['Audience'],
        'population_focuses': row['Population Focus'], 
        'location': row['Location'],
        'campuses': row['Campuses'], 
        'colleges': row['College eligibility'], 
        'availabilities': row['Availability'], 
        'deadline': row['Deadline'], 
        'innovation_stages': row['Innovation Type'], 
        'funding_amount': row['Funding Amount'],
        'topics': row['Topic'],
        'technologies': row['Technology'],
        'client_tags': row['Client Tags'],
        'notes': row['Notes'], 
        'approval_status': 0, 
        'approved_by': row['Approved by'],
        'updated_at': '', 
        'flagged': '', 
        'flagged_comment': ''
      }

      params, resource_hash = Resource.separate_params(record)
      r = Resource.create_resource(resource_hash)
      r.save(validate: false)
      Resource.create_associations(r, params)
      count = count + 1
      # if data is seeded from CSV file, forcefully gets added to database
      # this is because a majority of the seeded database has empty or invalid fields
      
    end

    flash[:notice] = "Added #{count} resources to the approval queue"
    redirect_to "/resources/unapproved.html"

  end

  def approve_many
    status = approve_many_status
    lst = params[:approve_list]
    if @user.nil?
      approve_many_sad_path("This action is unauthorized.", 401)
      return
    elsif not [0, 1].include? status
      approve_many_sad_path("Approval status must be either 0 or 1.", 403)
      return
    elsif (lst != 'all') and (lst.blank? or lst.any? {|id| not id.scan(/\D/).empty?})
      approve_many_sad_path("Approval list not formatted correctly.", 400)
      return
    else
      @resources = Resource.where(:approval_status => 0)
      if @resources.count < 1
        flash[:notice] = ("No resources to approve.")
        redirect_to "/resources/unapproved.html"
        return
      end

      @resources = get_resources(lst)
    end

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.include_has_many_params) }
      format.html do
        flash[:notice] = (@resources.size > 1 ? "Resources have" : "Resource has") + " been successfully approved."
        redirect_to "/resources/unapproved.html"
      end
    end
  end

  def archive_many
    lst = params[:approve_list]
    if @user.nil?
      approve_many_sad_path("This action is unauthorized.", 401)
      return
    else
      @resources = Resource.where(:approval_status => 0).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) 
    end

    if @resources.count < 1
      flash[:notice] = ("No resources to archive.")
      redirect_to "/resources/unapproved.html"
      return
    end

    @resources.each do |resource|
      r = Resource.update(resource.id, :approval_status => 2)
      r.save(validate: false)
    end

    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.include_has_many_params) }
      format.html do
        flash[:alert] = (@resources.size > 1 ? "All unapproved resources have" : "Resource has") + " been archived."
        redirect_to "/resources/unapproved.html"
      end
    end
  end
  

  def delete_many
    lst = params[:approve_list]
    if @user.nil?
      approve_many_sad_path("This action is unauthorized.", 401)
      return
    else
      @resources = Resource.where(:approval_status => 2).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) 
    end
    if @resources.count < 1
      flash[:notice] = ("No resources to delete.")
      redirect_to "/resources/archived.html"
      return
    end

    @resources.each do |resource|
      resource.destroy
    end
    respond_to do |format|
      format.json {render :json => @resources.to_json(:include => Resource.include_has_many_params) }
      format.html do
        flash[:alert] = (@resources.size > 1 ? "All archived resources have" : "Resource has") + " been permanently deleted."
        redirect_to "/resources/archived.html"
      end
    end
  end

  def get_resources(lst)
    resources = []
    if lst == 'all'
      Resource.where(:approval_status => 0).each do |resource|
        r = Resource.update(resource.id, :approval_status => 1, :approved_by => @user.email)
        r.save(validate: false) # for now, force update even if not valid
      end
      resources = Resource.all
    else
      resources = update_approvals_in_list(lst)
    end
    return resources
  end

  def edit
    if !Resource.guest_update_params_allowed?(resource_params) and @user == nil
      flash[:notice] = "You don't have permissions to update records"
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

  def flag
    id = params[:id]
    comment = params[:flagged_comment]
    r = Resource.update(id, :flagged => 1)
    r.save(validate: false)
    if r[:flagged_comment].length > 0
      r = Resource.update(id, :flagged_comment => r[:flagged_comment] + "; "+ comment)
    else
      r = Resource.update(id, :flagged_comment => comment);
    end
    
    r.save(validate: false)
    flash[:notice] = "Thank you for your feedback. A database admin will create fixes as soon as possible."
    redirect_back(fallback_location: root_path)
  end

  def archive
    id = params[:id]
    r = Resource.update(id, :approval_status => 2)
    r.save(validate: false)
    flash[:alert] = "Resource archived"
    redirect_back(fallback_location: root_path)
  end

  def restore
    id = params[:id]
    r = Resource.update(id, :approval_status => 0, :flagged => 0)
    r.save(validate: false)
    flash[:notice] = "Resource restored. It is now located in the approval queue."
    redirect_back(fallback_location: root_path)
  end

  def all
    if @user.nil?
      if request.format.json?
        render status: 400, json: {}.to_json
      else
        redirect_to "/resources.html"
      end
    else
      @resources = Resource.where(:approval_status => 1).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
      @all_values_hash = Resource.all_values_hash
      @has_many_hash = self.has_many_value_hash
      respond_to do |format|
        format.json {@resource.to_json(:include => Resource.include_has_many_params)}
        format.html
      end
    end
  end
  

  def unapproved
    if @user.nil?
      if request.format.json?
        render status: 400, json: {}.to_json
      else
        redirect_to "/resources.html"
      end
    else
      @resources = Resource.where(:approval_status => 0).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
      @resource_count = "#{@resources.size} resource" + (@resources.size != 1 ? "s" : "")
      @all_values_hash = Resource.all_values_hash
      @has_many_hash = self.has_many_value_hash
      @upload = ""
      respond_to do |format|
        format.json {@resource.to_json(:include => Resource.include_has_many_params)}
        format.html
      end
    end
  end

  def flagged
    if @user.nil?
      if request.format.json?
        render status: 400, json: {}.to_json
      else
        redirect_to "/resources.html"
      end
    else
      @resources = Resource.where(:flagged => 1).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
      @resource_count = "#{@resources.size} resource" + (@resources.size != 1 ? "s" : "")
      @all_values_hash = Resource.all_values_hash
      @has_many_hash = self.has_many_value_hash
      respond_to do |format|
        format.json {@resource.to_json(:include => Resource.include_has_many_params)}
        format.html
      end
    end
  end

  def archived
    if @user.nil?
      if request.format.json?
        render status: 400, json: {}.to_json
      else
        redirect_to "/resources.html"
      end
    else
      @resources = Resource.where(:approval_status => 2).includes(:types, :audiences, :client_tags, :population_focuses, :campuses, :colleges, :availabilities, :innovation_stages, :topics, :technologies) # eager load resources
      @resource_count = "#{@resources.size} resource" + (@resources.size != 1 ? "s" : "")
      @all_values_hash = Resource.all_values_hash
      @has_many_hash = self.has_many_value_hash
      respond_to do |format|
        format.json {@resource.to_json(:include => Resource.include_has_many_params)}
        format.html
      end
    end
  end
  
  private
  def set_user
    if request.format.json? and params.include? :api_key
      @user = User.where(:api_token => params[:api_key]).first
    else
      @user = current_user
    end
    params.delete :api_key
  end

  def approve_many_sad_path(notice, code)
    respond_to do |format|
      format.html {
        flash[:notice] = notice
        redirect_to "/resources/unapproved.html"
      }
      format.json { render status: code, json: {}.to_json }
    end
  end

  def approve_many_status
    status = 1
    if not params[:approval_status].nil?
      status = params[:approval_status].to_i
    end
    return status
  end

  def update_approvals_in_list(lst)
    if (status)
      status = 1
    end
    @resources = []
    lst.each do |id|
      if Resource.exists? :id => id
        r = Resource.update(id, :approval_status => status)
        r.save(validate: false)
        @resources << r
      end
    end
    return @resources
  end

  

end


