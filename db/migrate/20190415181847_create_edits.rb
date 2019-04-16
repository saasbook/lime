class CreateEdits < ActiveRecord::Migration[5.2]
  def change
    create_table :edits do |t|
      t.integer :resource_id
      t.string :user
      t.string :parameter
      t.timestamps
    end
  end
end
