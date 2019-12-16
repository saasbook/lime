class AddNumEmailsToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :num_emails, :integer, default: 0
  end
end
