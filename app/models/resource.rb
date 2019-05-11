class Resource < ActiveRecord::Base
  has_many :types
  has_many :audiences
  has_many :client_tags
  has_many :population_focuses
  has_many :campuses
  has_many :colleges
  has_many :availabilities
  has_many :innovation_stages
  has_many :topics
  has_many :technologies
  # validations: https://guides.rubyonrails.org/active_record_validations.html
  validates :title, :url, :contact_email, :location, :presence => true
  validates :desc, :presence => true, :length => {:maximum => 500}

  # def self.auth_params
  #   [:flagged, :approval_status, :approved_by]
  # end

  def self.include_has_many_params
    {:types => {:only => [:val]},
     :audiences => {:only => [:val]},
     :client_tags => {:only => [:val]},
     :population_focuses => {:only => [:val]},
     :campuses => {:only => [:val]},
     :colleges => {:ony => [:val]},
     :availabilities => {:only => [:val]},
     :innovation_stages => {:only => [:val]},
     :topics => {:only => [:val]},
     :technologies => {:only => [:val]}
    }
  end

  def self.guest_update_params_allowed?(resource_params)
     update_allowed = (((resource_params.keys.size <= 1) and
         (resource_params.keys[0] == "flagged" ) and (resource_params["flagged"] == '1')) or
         ((resource_params.keys[0] == "flagged" or resource_params.keys[0] == "flagged_comment") and
         (resource_params.keys[1] == "flagged" or resource_params.keys[1] == "flagged_comment") and resource_params["flagged"] == '1'))
    return update_allowed
  end

  # returns a list of all associations [:types, :audiences, :client_tags, :population_focuses, :campuses, ...]
  def self.has_many_associations
    Resource.reflect_on_all_associations(:has_many).map! { |association| association.name.to_sym }
  end

  def self.get_associations_hash(resource)
    return {:audiences => resource.audiences, :availabilities => resource.availabilities,
            :campuses => resource.campuses, :client_tags => resource.client_tags,
            :colleges => resource.colleges, :innovation_stages => resource.innovation_stages,
            :population_focuses => resource.population_focuses, :technologies => resource.technologies,
            :topics => resource.topics, :types => resource.types
    }
  end

  def self.filter(params)
    params = params.to_h.map {|k,v| [k.to_sym, v]}.to_h # convert ActiveRecord::Controller params into hash with symbol keys
    # puts 'inside filter - ' + params.to_s
    # Partition params into has_many fields and normal fields
    # has_many_hash = {k => [v1,v2,v3]} ; ex. {audiences => [undergrad, grad, alumni]}
    has_many_hash = {}
    params.each_key do |key|
      if self.has_many_associations.include?(key)
        # String variation (JSON request)
        if params[key].is_a?(String)
          has_many_hash[key] = params[key].split(',').map { |x| x.strip } # split by comma delimiter, and strip leading and trailing whitespace
        # List variation (HTML request)
        elsif params[key].is_a?(Array)
          has_many_hash[key] = params[key]
        end
        params.delete(key) # remove has_many key from params
      end
    end

    # puts 'has-many-hash : ' + has_many_hash.to_s
    # return early if there are no has_many fields
    if has_many_hash.empty?
      return Resource.where(params)
    else
      resources = Resource.where(params).includes(*Resource.has_many_associations)
      return self.filter_has_many_helper(resources, has_many_hash)
    end
  end

  def self.filter_has_many_helper(resources, has_many_hash)
    filtered = [] # list of returned records
    resources.find_each do |resource|
      associations_hash = self.get_associations_hash(resource)
      bool_arr = []
      # for each has_many query, check if the current record's has_many field contains all values in the query
      has_many_hash.each do |field, values|
        bool_arr.append (associations_hash[field].records.collect(&:val) & values).sort == values.sort
      end
      # if all queries return true, append the record to the returned value
      if bool_arr.all?
        filtered.append resource
      end
    end
    # return ActiveRecord::Relation instead of array so that ActiveRecord calls can be chained outside this function
    return Resource.where(id: filtered.map(&:id))
  end

  def self.cast_param_vals(params)
    params.values_at(
        :flagged_comment,:title,:url,:contact_email,:location)
        .compact.each { |field| params[field] = params[field].to_s }
    if params[:flagged]
      params[:flagged] = params[:flagged].to_i
    end

    if params[:approval_status]
      params[:approval_status] = params[:approval_status].to_i
    end

    return params
  end

  def self.log_edits(params)
    # if the field exists, then create and Edit
    params.values_at(
        :flagged,:approval_status,:title,:url,:contact_email,:location)
        .compact.each { |field| self.edit_helper(params[:id], field) }
  end

  def self.edit_helper(id, param)
    @edit = Edit.new(:resource_id => id, :user => @user, :parameter => param)
    @edit.save!
  end

  def self.create_resource(params)
    params, resource_hash = Resource.separate_params(params)
    resource = Resource.create(resource_hash)
    if resource.valid?
      Resource.create_associations(resource, params)
    end
    return resource
  end

  def self.update_resource(id, params)
    params, resource_hash = Resource.separate_params(params)
    resource = Resource.update(id, resource_hash)
    Resource.create_associations(resource, params)
    return resource
  end

  def self.separate_params(params)
    params = params.to_h.map {|k,v| [k.to_sym, v]}.to_h
    resource_hash = {}
    params.each do |field, val|
      if self.has_many_associations.include? field
        if val.is_a?(String)
          params[field] = val.split(',')
        end
      else
        params.delete field
        resource_hash[field] = val
      end
    end
    return params, resource_hash
  end

  def self.create_associations(resource, params)
    fields_hash = self.get_associations_hash(resource)
    fields_hash.each do |field, association|
      # puts params[field].to_s
      association.delete_all
      if params[field] != nil
        params[field].each do |val|
          association.create(:val => val)
        end
      end
    end
  end

  def self.find_missing_params(params)
    missing = []
    Resource.get_required_resources.each do |r|
      if !params.include?(r) or params[r] == ""
        missing.append r
      end
    end
    return missing
  end

  # this method is here
  # if filtering by location, filtering should behave as the following
  # if the location has no resources, find the parent location, and return resources for the parent location
  def self.location_helper(params)
    exclusive = (params[:exclusive] == true)
    params.delete :exclusive
    
    location = params[:location]
    if location.nil? or exclusive
      return self.filter(params)
    end

    locations = Location.child_locations(location)
    resources = Resource.none

    locations.each do |location|
      params[:location] = location
      resources = resources.or(self.filter(params))
    end
    return resources
  end

  def self.get_required_resources
    return ["title", "url", "contact_email", "location", "types", "audiences", "desc"]
  end

  def self.all_values_hash
    {
        "Contact Email" => "contact_email",
        "Contact Name" => "contact_name",
        "Contact Phone" => "contact_phone",
        "URL" => "url",
        "Description" => "desc",
        "Location" => "location",
        "Resource Email" => "resource_email",
        "Resource Phone" => "resource_phone",
        "Address" => "address",
        "Funding Amount" => "funding_amount",
        "Deadline" => "deadline",
        "Notes" => "notes",
        'Types' => "types",
        'Audiences' => "audiences",
        'Campuses' => "campuses",
        'Innovation Stages' => "innovation_stages",
        'Population Focuses' => "population_focuses",
        'Availabilities' => "availabilities",
        'Topics' => "topics",
        'Technologies' => "technologies",
        'Client tags' => "client_tags",
        "Approval Status" => "approval_status",
        "Approved By" => "approved_by",
        "Flagged" => "flagged",
        "Flagged Comment" => "flagged_comment",
        "Created At" => "created_at",
        "Updated At" => "updated_at"
    }
  end

  def self.all_public_values_hash
    {
        "URL" => "url",
        "Description" => "desc",
        "Location" => "location",
        "Resource Email" => "resource_email",
        "Resource Phone" => "resource_phone",
        "Address" => "address",
        "Funding Amount" => "funding_amount",
        "Deadline" => "deadline",
        "Notes" => "notes",
        'Types' => "types",
        'Audiences' => "audiences",
        'Campuses' => "campuses",
        'Innovation Stages' => "innovation_stages",
        'Population Focuses' => "population_focuses",
        'Availabilities' => "availabilities",
        'Topics' => "topics",
        'Technologies' => "technologies",
        'Client tags' => "client_tags",
        "Created At" => "created_at",
        "Updated At" => "updated_at"
    }
  end
end


