class Technology < ActiveRecord::Base
  belongs_to :resource

  def self.get_values
    ['Networks', 'Internet of Things', 'Cyber Security', 'Computing', 'Big Data & Quantum Computing', 'Computer Technology']
  end

  def self.count(label)
    return Technology.where(:val => label).length;
  end
end
