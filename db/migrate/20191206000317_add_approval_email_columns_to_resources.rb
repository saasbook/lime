class AddApprovalEmailColumnsToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :approval_num, :integer, default: 0
    add_column :resources, :approval_last, :datetime
  end
end
