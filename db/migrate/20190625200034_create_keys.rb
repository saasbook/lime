class CreateKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :keys do |t|
      t.string :registration_key

      t.timestamps
    end
  end
end
