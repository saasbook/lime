class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :title             # required
      t.string :url               # required, validate
      t.string :contact_email     # required, valiate, hidden
      t.text :desc                # required, validate
      t.string :location          # required
      t.string :resource_email    # validate
      t.string :resource_phone    # validate
      t.string :address
      t.string :contact_name      # hidden
      t.string :contact_phone     # validate, hidden
      t.datetime :deadline        # validate
      t.text :notes               
      t.integer :approval_status  # hidden
      t.string :approved_by       # hidden
      t.integer :flagged          # hidden??
      t.text :flagged_comment     # hidden??
      t.timestamps
      # attachments??
    end

    create_table :types do |t|
      t.belongs_to :resource      # required
      t.string :name              # type name
      t.timestamps
    end

    create_table :audiences do |t|
      t.belongs_to :resource      # required
      t.string :type              # audience type
      t.timestamps
    end

    create_table :tags do |t|
      t.belongs_to :resource     # NOT required
      t.string :name             # tag name
      t.timestamps
    end

    create_table :population_focuses do |t|
      t.belongs_to :resource     # NOT required
      t.string :type             # population focus type
      t.timestamps
    end

    create_table :campuses do |t|
      t.belongs_to :resource     # NOT required
      t.string :name             # campus name
      t.timestamps
    end

    create_table :colleges do |t|
      t.belongs_to :resource     # NOT required
      t.string :name             # college name
      t.timestamps
    end

    create_table :availabilities do |t|
      t.belongs_to :resource     # NOT required
      t.string :type             # availability type
      t.timestamps
    end

    create_table :innovation_stages do |t|
      t.belongs_to :resource     # NOT required
      t.string :name             # innovation stage name
      t.timestamps
    end

    create_table :topics do |t|
      t.belongs_to :resource    # NOT required
      t.string :name            # topic name
      t.timestamps
    end

    create_table :technologies do |t|
      t.belongs_to :resource    # NOT required
      t.string :type            # technology type
      t.timestamps
    end
  end
end
