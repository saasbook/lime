class InnovationStage < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Research-Academia', 'Research', 'Project', 'Startups', 'Clubs']
  end
end
