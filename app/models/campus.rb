class Campus < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Berkeley', 'Davis', 'Merced', 'Santa Cruz']
  end

  def self.count(label)
    return Campus.where(:val => label).length;
  end
end
