class PopulationFocus < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Women', 'Under-represented minority', 'LGTBQA+', 'People of African descent', 'People of Latin American descent',
    'First generation college students', 'Low Income', 'Veterans']
  end
end
