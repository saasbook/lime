class College < ActiveRecord::Base
  belongs_to :resource

  def self.count(label)
    return College.where(:val => label).length;
  end
end
