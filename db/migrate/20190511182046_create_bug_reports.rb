class CreateBugReports < ActiveRecord::Migration[5.2]
  def change
    create_table :bug_reports do |t|
      t.string :desc
      t.boolean :closed

      t.timestamps
    end
  end
end
