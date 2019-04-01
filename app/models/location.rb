class Location < ActiveRecord::Base
  belongs_to :parent, :class_name => "Location", :foreign_key => "parent_location_id"
  has_many :child, :class_name => "Location", :foreign_key => "child_location_id"
  validates :parent, :presence => true
end
