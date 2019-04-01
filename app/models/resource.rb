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
  has_one  :location
  # validations: https://guides.rubyonrails.org/active_record_validations.html
  # validates :title, :url, :contact_email, :location, :types, :audiences, :presence => true
  # validates :desc, :presence => true, :length => {:maximum => 500}

  # returns a list of all associations [:types, :audiences, :client_tags, :population_focuses, :campuses, ...]
  @@has_many_associations = Resource.reflect_on_all_associations(:has_many).map! { |association| association.name.to_sym }

  def self.filter(params)
    params = params.to_h.map {|k,v| [k.to_sym, v]}.to_h # convert ActiveRecord::Controller params into hash with symbol keys

    # Partition params into has_many fields and normal fields
    # has_many_hash = {k => [v1,v2,v3]} ; ex. {audiences => [undergrad, grad, alumni]}
    has_many_hash = {}
    params.each_key do |key|
      if @@has_many_associations.include?(key)
        has_many_hash[key] = params[key].split(',').map { |x| x.strip } # split by comma delimiter, and strip leading and trailing whitespace
        params.delete(key) # remove has_many key from params
      end
    end

    filtered = [] # return value (list of records matching query)
    resources = Resource.where(params) # filter by singular parameters first

    # return early if there are no has_many fields
    if has_many_hash.empty?
      return resources
    else #todo - find a way to clean up this block. :(  [matching the has_many queries]
      # for each of the candidate resources filtered by the singular parameters, check if it matches the has_many queries
      resources.find_each do |resource|
        associations_hash = {:types => resource.types, :audiences => resource.audiences, :client_tags => resource.client_tags,
                             :population_focuses => resource.population_focuses, :campuses => resource.campuses, :colleges => resource.colleges,
                             :availabilities => resource.availabilities, :innovation_stages => resource.innovation_stages, :topics => resource.topics,
                             :technologies => resource.technologies
        }
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
  end


  # this method is here
  # if filtering by location, filtering should behave as the following
  # if the location has no resouces, find the parent location, and return resources for the parent location
  # if the location has child locations, also return those locations
  def self.location_helper(params, resources)
    locations = params.to_h.map {|k,v| [k.to_sym, v]}.to_h[:location].split(',')
    logger.debug(params)

    locations.each do |loc|
      resources = resources.or(self.find_parent_resources(loc, params))
    end

    return resources
  end

  def self.find_parent_resources(location, params)

    if Location.exists?(location) and Location.find(location).parent
      parent = Location.find(location).parent
      params[:location] = parent
      # make a hash of :location to loc, call Resource.filter, then combine the 2 lists, if parent has parent then do
      # recusive call
      resources = self.filter(params)
      resources.or(self.find_parent_resources(parent, params))
      return resources
    end
    return Resource.none
  end

  #todo verify email and url beforehand?
  def self.validate_email_url(email, url)
  end

  def self.get_required_resources
    return [:title, :url, :contact_email, :location, :types, :audiences, :desc]
  end 

  def self.get_has_many_hashes(params)
    has_many_hash = {}
    params.each do |key, value|
      # puts "oof"
      # puts key
      # puts value
      if @@has_many_associations.include?(key.to_sym)
        # puts "loop"
        has_many_hash[key] = params[key].split(',').map { |x| x.strip } # split by comma delimiter, and strip leading and trailing whitespace
        params.delete(key) # remove has_many key from params
      end
    end
    return has_many_hash
  end

end


