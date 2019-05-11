require 'geocoder'

class Location < ActiveRecord::Base
  belongs_to :parent, :class_name => "Location"
  has_many :children, :class_name => "Location", :foreign_key => 'parent_id'
  validate :parent_presence

  def self.seed
    location_hashes = [{'location' => 'USA', 'parent' => 'Global'},
                      {'location' => 'California', 'parent' => 'USA'},
                      {'location' => 'Berkeley', 'parent' => 'California'},
                      {'location' => 'Davis', 'parent' => 'California'},
                      {'location' => 'Stanfurd', 'parent' => 'California'},
                      {'location' => 'Siberia', 'parent' => 'Global'}
                  ]
    global = Location.create :val => "Global"
    global.save :validate => false
    location_hashes.each do |location|
      parent = Location.where(:val => location['parent'].to_s).first
      Location.create! :val => location['location'], :parent_id => parent.id
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
    result = Geocoder.search(name).first
    nesting_helper(result, result.type, name)
  end

  def self.nesting_helper(result, type, name)
    # check in top - down manner, country to curr type
    if type == "administrative"
      # separate counties, states, and countries
      if name == result.country
        add_location(name, "Global")
      elsif name == result.state
        add_location(name, result.country)
      elsif name == result.county
        add_location(name, result.state)
      end
    elsif type == "city" || type == "village" || type == "town"
      add_location(name, result.state)
    elsif type == "university"
      add_location(name, result.city)
    else
      # not one of the above, maybe add all fields to database
    end
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

  def self.get_values 
    ['Global', 'USA', 'California', 'Berkeley', 'Davis', 'Stanfurd', 'Siberia']
  end

  def self.get_locations
    {
        'location' => Location.get_values,
    }
  end
end
