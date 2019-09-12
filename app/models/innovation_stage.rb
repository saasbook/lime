class InnovationStage < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Research-Academia', 'Research', 'Project', 'Startups', 'Clubs']
  end

  def self.count(label)
    return InnovationStage.where(:val => label).length;
  end
end
