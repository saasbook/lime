class AddLastEmailSentToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :last_email_sent, :datetime
  end
end
