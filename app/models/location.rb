class Location < ActiveRecord::Base
  belongs_to :parent, :class_name => "Location"
  has_many :children, :class_name => "Location"
  validate :parent_presence

  def parent_presence
    (not parent_id.blank?) or (val == "Global" and Location.where(:val => "Global").empty?)
  end
end
