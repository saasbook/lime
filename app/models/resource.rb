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
    # Partition params into has_many fields and normal fields
    # has_many_hash = {k => [v1,v2,v3]} ; ex. {audiences => [undergrad, grad, alumni]}
    has_many_hash = {}
    params.each_key do |key|
      if self.has_many_associations.include?(key)
        has_many_hash[key] = params[key].split(',').map { |x| x.strip } # split by comma delimiter, and strip leading and trailing whitespace
        params.delete(key) # remove has_many key from params
      end
    end

    resources = Resource.where(params) # filter by singular parameters first
    # return early if there are no has_many fields
    if has_many_hash.empty?
      return resources
    else
      return self.filter_has_many_helper(resources, has_many_hash)
    end
  end

  def self.filter_has_many_helper(resources, has_many_hash)
    #matching the has_many queries is a potential bottleneck! O(NK) sorts and set operations
    # where N = # records and K = # fields (max 10)]
    # alternative is to do a 11 way join, and check the existence of each value of the query
    # for each of the candidate resources filtered by the singular parameters, check if it matches the has_many queries
    filtered = [] # list of returned records
    resources.find_each do |resource|
      associations_hash = self.get_associations_hash(resource)
      bool_arr = []
      # for each has_many query, check if the current record's has_many field contains all values in the query
      has_many_hash.each do |field, values|
        bool_arr.append (associations_hash[field].records.map { |x| x.val } & values).sort == values.sort
      end
      # if all queries return true, append the record to the returned value
      if bool_arr.all?
        filtered.append resource
      end
    end
    # return ActiveRecord::Relation instead of array so that ActiveRecord calls can be chained outside this function
    return Resource.where(id: filtered.map(&:id))
  end

  def self.create_resource(params)
    params = params.to_h.map {|k,v| [k.to_sym, v]}.to_h

    resource_hash = {}
    params.each do |field, val|
      if self.has_many_associations.include? field
        params[field] = val.split(',')
      else
        resource_hash[field] = val
      end
    end

    resource = Resource.create!(resource_hash)
    
    fields_hash = self.get_associations_hash(resource)
    fields_hash.each do |field, association|
      if params[field] != nil
        params[field].each do |val|
          association.create(:val => val)
        end
      end
    end
    return resource
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

    locations = Resource.ancestor_locations(location)
    resources = Resource.none

    locations.each do |location|
      params[:location] = location
      resources = resources.or(self.filter(params))
    end
    return resources
  end

  # returns list of locations that match given location, including the location and all of its ancestors
  def self.ancestor_locations(location)
    if location == nil or !Location.exists?(:val => location)
      return []
    end
    parent = Location.find_by_val(location).parent
    return [location] + self.ancestor_locations(parent&.val)
  end

  def self.get_required_resources
    return ["title", "url", "contact_email", "location", "types", "audiences", "desc"]
  end

end


