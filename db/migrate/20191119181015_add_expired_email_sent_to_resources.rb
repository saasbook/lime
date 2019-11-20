class AddExpiredEmailSentToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :expired_email_sent, :boolean, default: false
  end
end
