class AddEmailToBugReport < ActiveRecord::Migration[5.2]
  def change
    add_column :bug_reports, :email, :string
  end
end
