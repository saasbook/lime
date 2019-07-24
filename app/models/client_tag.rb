class ClientTag < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['BearX.co', 'WITI', 'CITRIS', 'OnRamp']
  end

  def self.count(label)
    return ClientTag.where(:val => label).length;
  end
end
