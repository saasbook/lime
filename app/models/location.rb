require 'geocoder'


class Location < ActiveRecord::Base
  belongs_to :parent, :class_name => "Location"
  has_many :children, :class_name => "Location", :foreign_key => 'parent_id'
  validate :parent_presence

  def state_names
    %w(Alaska Alabama Arkansas American\ Samoa Arizona California Colorado Connecticut District\ of\ Columbia Delaware Florida Georgia Guam Hawaii Iowa Idaho Illinois Indiana Kansas Kentucky Louisiana Massachusetts Maryland Maine Michigan Minnesota Missouri Mississippi Montana North\ Carolina North\ Dakota Nebraska New\ Hampshire New\ Jersey New\ Mexico Nevada New\ York Ohio Oklahoma Oregon Pennsylvania Puerto\ Rico Rhode\ Island South\ Carolina South\ Dakota Tennessee Texas Utah Virginia Virgin\ Islands Vermont Washington Wisconsin West\ Virginia Wyoming)
  end
  

  def self.seed
    location_hashes = [{'location' => 'USA', 'parent' => 'Global'},
                      {'location' => 'International', 'parent' => 'Global'},
                      {'location' => 'California', 'parent' => 'USA'},
                      {'location' => 'Bay Area', 'parent' => 'California'},
                      {'location' => 'Berkeley', 'parent' => 'Bay Area'},
                      {'location' => 'UC Berkeley', 'parent' => 'Berkeley'}
                      
                  ]
    global = Location.create :val => "Global"
    global.save :validate => false
    location_hashes.each do |location|
      add_location(location['location'].to_s, location['parent'].to_s)
    end
  end

  def self.nest_location(name)
    #ignore if already in the locations database
    if Location.exists? :val => name
      return
    elsif Location.first.nil?
      self.seed
    end

    # find the location info using the geocoder
    # more info: https://github.com/alexreisner/geocoder
    result = nesting_helper(name)
    # TODO: add front-end functionality to notify user if location is valid
    # returned boolean currently has no functionality
  end

  # find parent using city-state (unsure if gem features have become deprecated)
  # more info: https://github.com/loureirorg/city-state
  # result = Geocoder.search(name).first
  # From city-state docs: 
  # "MaxMind updates their databases weekly on tuesdays. 
  # To get a new and updated version, you can update with: 
  # CS.update" 
  def self.nesting_helper(name)
    countries = CS.get
    states = CS.states(:us).values
    cali_cities = CS.cities(:ca, :us)
    # check in top - down manner
    if countries.include? name
      add_location(name, "Global")
    elsif states.include? name
      add_location(name, "USA")
    elsif cali_cities.include? name
      add_location(name, "California")
    else
      # not one of the above, invalid location input
      # for now, let resource be added but be put into Global category
      # (ideally replace this funcionality)
      add_location(name, "Global")
      return false
    end
    return true
  end

  def self.add_location(name, parent_name)
    if !Location.exists? :val => parent_name
      # if location not in the database, call nest_location and recurse
      nest_location(parent_name)
    end

    if (!Location.exists? :val => name) && (Location.exists? :val => parent_name)
      parent_id = Location.where(:val => parent_name).first
      location = Location.create!( :val => name, :parent_id => parent_id.id)
      location.save
    end

  end

  # returns list of locations that match given location, including the location and all of its children
  def self.child_locations(location)
    if (location == "United States")
      location = "USA"
    end
    if location == nil or !Location.exists?(:val => location)
      return []
    end

    loc = Location.where(:val => location).first
    
    children = Location.where(:parent_id => loc.id).map {|location| location.val}.flatten
    all_descendents = []
    i = 0
    while i < children.count do
      child = children[i]
      all_descendents.concat(self.child_locations(child))
      i += 1
    end

    return all_descendents.push(location)
  end

  def parent_presence
    (not parent.blank?) or (val == "Global" and Location.where(:val => "Global").empty?)
  end

  # gets the parent name String value using a location's parent_id (given the location's value)
  def self.get_parent(location)
    if (location == "United States")
      location = "USA"
    end
    location_data = Location.where(:val => location).first
    if location_data != nil && location != "Global"
      return Location.where(:id => location_data.parent_id).first.val
    else
      return ""
    end
  end

  def self.get_values 

    # gets values of all locations in the database, not just the current location
    all_locations = Array.new
    Location.all.each do |loc|
      all_locations.push(loc.val)
    end
    return all_locations
  end

  def self.get_locations
    {
        'location' => Location.get_values,
    }
  end

  def self.count(label)
    return Location.where(:val => label).length;
  end
end
