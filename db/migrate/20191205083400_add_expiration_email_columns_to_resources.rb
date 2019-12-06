class AddExpirationEmailColumnsToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :expired_num, :integer, default: 0
    add_column :resources, :expired_last, :datetime
  end
end
