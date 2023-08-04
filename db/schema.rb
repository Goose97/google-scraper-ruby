# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_27_072004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "keyword_status", ["pending", "processing", "succeeded", "failed"]
  create_enum "search_entry_kind", ["ads", "non_ads"]
  create_enum "search_entry_position", ["top", "bottom", "main_search"]

  create_table "keyword_search_entries", id: :serial, force: :cascade do |t|
    t.enum "kind", null: false, enum_type: "search_entry_kind"
    t.string "urls", default: [], null: false, array: true
    t.enum "position", null: false, enum_type: "search_entry_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "keyword_id", null: false
    t.index ["keyword_id"], name: "index_keyword_search_entries_on_keyword_id"
  end

  create_table "keywords", id: :serial, force: :cascade do |t|
    t.string "content", limit: 255, null: false
    t.enum "status", default: "pending", null: false, enum_type: "keyword_status"
    t.text "result_page_html"
    t.integer "links_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "keyword_search_entries", "keywords", on_delete: :cascade
end
