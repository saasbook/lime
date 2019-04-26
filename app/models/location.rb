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

  def self.child_locations(location)

    if location == nil or !Location.exists?(:val => location)
      # location does not exist
      return []
    end

    loc = Location.where(:val => location).first
    # just extract the names so we can do a normal loop
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
end
