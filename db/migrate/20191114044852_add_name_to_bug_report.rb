class AddNameToBugReport < ActiveRecord::Migration[5.2]
  def change
    add_column :bug_reports, :name, :string
  end
end
