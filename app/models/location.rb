class Location < ActiveRecord::Base
  belongs_to :resource
  belongs_to :parent, :class_name => "Location"
  has_many :child, :class_name => "Location"
  validates :parent, :presence => true
end
