class Campus < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Berkeley', 'Davis', 'Merced', 'Santa Cruz']
  end
end
