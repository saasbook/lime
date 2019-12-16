class AddBrokenUrlColumnsToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :broken_num, :integer, default: 0
    add_column :resources, :broken_last, :datetime
  end
end
