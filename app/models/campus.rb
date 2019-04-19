class Campus < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Davis', 'Berkeley', 'Merced', 'Santa Cruz']
  end
end
