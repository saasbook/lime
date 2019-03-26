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
  validates :title, :url, :contact_email, :location, :types, :audiences, :presence => true
  validates :desc, :presence => true, :length => {:maximum => 500}

  @@has_many_associations = Resource.reflect_on_all_associations(:has_many).map! { |association| association.name.to_sym }

  def self.filter(params)
    params = params.to_h
    # Split params into has_many_fields and normal fields
    # has_many_hash = {k => [v1,v2,v3]} ; ex. {audiences => [undergrad, grad, alumni]}
    has_many_hash = {}
    params = params.map {|k,v| [k.to_sym, v]}.to_h # change keys into symbols
    params.each_key do |key|
      if @@has_many_associations.include?(key)
        has_many_hash[key] = params[key].split(',') # split by comma delimiter
        has_many_hash[key] = has_many_hash[key].map do |x| x.strip end # just to be safe, strip leading and trailing whitespace
        params.delete(key)
      end
    end
    puts 'params', params
    puts 'hmh', has_many_hash

    filtered = [] # return value (list of records matching query)
    resources = Resource.where(params) # filter by singular parameters first

    puts 'resources:' , resources
    # return early if there are no has_many fields
    if has_many_hash.empty?
      return resources
    else #todo - find a way to clean up this block. :(  [matching the has_many queries]
      print 'hmh : ' + has_many_hash.to_s
      # for each of the candidate resources, check if it matches the has_many queries
      resources.find_each do |resource|
        associations_hash = {:types => resource.types, :audiences => resource.audiences, :client_tags => resource.client_tags,
                             :population_focuses => resource.population_focuses, :campuses => resource.campuses, :colleges => resource.colleges,
                             :availabilities => resource.availabilities, :innovation_stages => resource.innovation_stages, :topics => resource.topics,
                             :technologies => resource.technologies
        }
        bool_arr = []
        # for each has_many query, check if the current record's has_many field contains all values in the query
        has_many_hash.each do |field, values|
          bool_arr.append (associations_hash[field].records.map do |x| x.val end & values).sort == values.sort
        end
        # if all queries return true, append the record to the returned value
        if bool_arr.all?
          filtered.append resource
        end
      end
      return Resource.where(id: filtered.map(&:id))
    end
  end

end


