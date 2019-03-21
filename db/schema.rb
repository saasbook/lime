# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_21_100624) do

  create_table "audiences", force: :cascade do |t|
    t.integer "resource_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_audiences_on_resource_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer "resource_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_availabilities_on_resource_id"
  end

  create_table "campuses", force: :cascade do |t|
    t.integer "resource_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_campuses_on_resource_id"
  end

  create_table "colleges", force: :cascade do |t|
    t.integer "resource_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_colleges_on_resource_id"
  end

  create_table "innovation_stages", force: :cascade do |t|
    t.integer "resource_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_innovation_stages_on_resource_id"
  end

  create_table "population_focuses", force: :cascade do |t|
    t.integer "resource_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_population_focuses_on_resource_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "contact_email"
    t.text "desc"
    t.string "location"
    t.string "resource_email"
    t.string "resource_phone"
    t.string "address"
    t.string "contact_name"
    t.string "contact_phone"
    t.datetime "deadline"
    t.text "notes"
    t.integer "approval_status"
    t.string "approved_by"
    t.integer "flagged"
    t.text "flagged_comment"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "resource_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_tags_on_resource_id"
  end

  create_table "technologies", force: :cascade do |t|
    t.integer "resource_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_technologies_on_resource_id"
  end

  create_table "topics", force: :cascade do |t|
    t.integer "resource_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_topics_on_resource_id"
  end

  create_table "types", force: :cascade do |t|
    t.integer "resource_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_types_on_resource_id"
  end

end
