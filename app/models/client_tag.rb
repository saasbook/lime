class ClientTag < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['BearX.co', 'WITI', 'CITRIS', 'OnRamp']
  end
end
