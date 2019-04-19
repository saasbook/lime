class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :title             # required
      t.string :url               # required, validate
      t.string :contact_email     # required, validate, hidden
      t.text :desc                # required, validate
      t.string :resource_email    # validate
      t.string :resource_phone    # validate
      t.string :address
      t.string :contact_name      # hidden
      t.string :contact_phone     # validate, hidden
      t.datetime :deadline        # validate
      t.text :notes               # validate, 1000 chars
      t.string :funding_amount    # validate
      t.string :location          # required
      t.integer :approval_status  # hidden
      t.string :approved_by       # hidden
      t.integer :flagged          # hidden?? yes
      t.text :flagged_comment     # hidden?? yes
      t.timestamps
    end

    create_table :locations do |t|
      t.belongs_to :parent, :class_name => "Location"
      t.string :val
      t.timestamps
    end

    create_table :types do |t|
      t.belongs_to :resource      # required
      t.string :val              # type name
      t.timestamps
      t.index [:resource_id], name: "index_types_on_resource_id"
    end

    create_table :audiences do |t|
      t.belongs_to :resource      # required
      t.string :val              # audience type
      t.timestamps
      t.index [:resource_id], name: "index_audiences_on_resource_id"
    end

    create_table :client_tags do |t| # hidden
      t.belongs_to :resource     # NOT required
      t.string :val             # client name
      t.timestamps
      t.index [:resource_id], name: "index_client_tags_on_resource_id"
    end

    create_table :population_focuses do |t|
      t.belongs_to :resource     # NOT required
      t.string :val             # population focus type
      t.timestamps
      t.index [:resource_id], name: "index_population_focuses_on_resource_id"
    end

    create_table :campuses do |t|
      t.belongs_to :resource     # NOT required
      t.string :val             # campus name
      t.timestamps
      t.index [:resource_id], name: "index_campuses_on_resource_id"
    end

    create_table :colleges do |t|
      t.belongs_to :resource     # NOT required
      t.string :val             # college name
      t.timestamps
      t.index [:resource_id], name: "index_colleges_on_resource_id"
    end

    create_table :availabilities do |t|
      t.belongs_to :resource     # NOT required
      t.string :val             # availability type
      t.timestamps
      t.index [:resource_id], name: "index_availabilities_on_resource_id"
    end

    create_table :innovation_stages do |t|
      t.belongs_to :resource     # NOT required
      t.string :val             # innovation stage name
      t.timestamps
      t.index [:resource_id], name: "index_innovation_stages_on_resource_id"
    end

    create_table :topics do |t|
      t.belongs_to :resource    # NOT required
      t.string :val            # topic name
      t.timestamps
      t.index [:resource_id], name: "index_topics_on_resource_id"
    end

    create_table :technologies do |t|
      t.belongs_to :resource    # NOT required
      t.string :val            # technology type
      t.timestamps
      t.index [:resource_id], name: "index_technologies_on_resource_id"
    end
  end
end
