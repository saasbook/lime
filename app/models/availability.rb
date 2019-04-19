class Availability < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Rolling', 'Summer', 'One time', 'Fall', 'Spring', 'Winter']
  end
end
