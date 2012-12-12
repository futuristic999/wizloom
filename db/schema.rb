# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121009173324) do

  create_table "attr_values", :force => true do |t|
    t.integer "entry_id"
    t.integer "attr_id"
    t.string  "value"
    t.string  "value_type"
  end

  create_table "attrs", :force => true do |t|
    t.integer "entity_id"
    t.string  "name"
    t.string  "label"
    t.string  "default_value"
    t.string  "options"
    t.string  "unit"
    t.string  "value_type"
    t.integer "display_order"
  end

  create_table "blocks", :force => true do |t|
    t.string   "entry_type"
    t.string   "view_type"
    t.string   "filter"
    t.string   "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
    t.integer  "entry_id"
    t.string   "name"
    t.integer  "associated_entry_id"
    t.boolean  "is_primary_block"
    t.string   "block_type"
  end

  create_table "board_blocks", :force => true do |t|
    t.integer "board_id"
    t.integer "block_id"
    t.integer "display_order"
  end

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.string   "display"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "config"
    t.integer  "topic_id"
  end

  create_table "books", :force => true do |t|
    t.string "name"
    t.string "book_type"
    t.string "topic_ids"
    t.string "display"
  end

  create_table "comments", :force => true do |t|
    t.string   "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field_id"
  end

  create_table "data_keys", :force => true do |t|
    t.string "key"
    t.string "default_value"
    t.string "options"
    t.string "data_type"
    t.string "unit"
  end

  create_table "entities", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "template_id"
    t.integer "owner_id"
  end

  create_table "entries", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "creator"
    t.string   "status"
    t.boolean  "refresh_html"
    t.integer  "fieldvalues_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entry_type"
    t.string   "descriptor"
    t.string   "topic_ids"
    t.integer  "entity_id"
  end

  add_index "entries", ["fieldvalues_id"], :name => "index_entries_on_fieldvalues_id"
  add_index "entries", ["template_id"], :name => "index_entries_on_template_id"

  create_table "entry_associations", :force => true do |t|
    t.integer "entry_id"
    t.integer "associated_entry_id"
    t.integer "list_id"
    t.string  "association_type"
    t.integer "display_order"
  end

  create_table "entry_data", :force => true do |t|
    t.integer "entry_id"
    t.integer "data_id"
    t.string  "data_key"
    t.string  "data_value"
    t.date    "journal_date"
  end

  create_table "entry_properties", :force => true do |t|
    t.integer "entry_id"
    t.integer "property_id"
    t.string  "property_name"
    t.string  "property_value"
  end

  create_table "entry_type_properties", :force => true do |t|
    t.integer "entry_type_id"
    t.string  "name"
    t.string  "default_value"
    t.string  "options"
    t.string  "data_type"
    t.string  "unit"
    t.string  "key"
  end

  create_table "entry_types", :force => true do |t|
    t.string  "type_code"
    t.integer "default_template_id"
    t.string  "template_ids"
    t.integer "owner_id"
    t.string  "name"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "topic_id"
    t.string   "activity_type"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_metadata", :force => true do |t|
    t.integer "fieldvalue_id"
    t.string  "key"
    t.string  "value"
  end

  create_table "field_values", :force => true do |t|
    t.integer  "entry_id"
    t.string   "label"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "list_descriptor"
    t.integer  "list_display_order"
    t.integer  "field_id"
  end

  add_index "field_values", ["entry_id"], :name => "index_field_values_on_entry_id"

  create_table "fields", :force => true do |t|
    t.string   "label"
    t.string   "options"
    t.string   "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
    t.string   "style"
    t.integer  "display_order"
    t.string   "fieldtype"
    t.string   "fieldname"
    t.integer  "auto_list_id"
    t.string   "list_item_type"
    t.string   "list_item_descriptor"
    t.integer  "list_descriptor_id"
  end

  create_table "list_descriptors", :force => true do |t|
    t.string  "list_type"
    t.string  "item_class"
    t.string  "item_type_id"
    t.string  "filter"
    t.string  "order_by"
    t.integer "associated_entry_id"
  end

  create_table "locations", :force => true do |t|
    t.string  "address"
    t.string  "street_number"
    t.string  "street"
    t.string  "city"
    t.string  "state"
    t.integer "zipcode"
    t.integer "field_id"
  end

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.integer  "location_id"
    t.datetime "starts"
    t.datetime "ends"
    t.date     "due_date"
    t.datetime "due_time"
    t.string   "status"
    t.string   "repeat_pattern"
    t.boolean  "alert"
    t.integer  "user_id"
    t.integer  "owner_id"
    t.integer  "field_id"
  end

  create_table "template_data_keys", :force => true do |t|
    t.integer "template_id"
    t.integer "data_key_id"
    t.string  "label"
    t.integer "display_order"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.integer  "creator"
    t.text     "xml"
    t.text     "theme"
    t.boolean  "refresh_html"
    t.string   "status"
    t.time     "created"
    t.time     "modified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "stub"
    t.text     "cached_html"
  end

  create_table "topic_associations", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "associated_topic_id"
    t.string   "association_type"
    t.string   "config"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_entries", :force => true do |t|
    t.integer "topic_id"
    t.integer "entry_id"
    t.integer "display_order"
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.string   "config"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "template_ids"
  end

  create_table "urls", :force => true do |t|
    t.string  "name"
    t.string  "location"
    t.string  "description"
    t.string  "tags"
    t.string  "keyword"
    t.integer "user_id"
    t.integer "field_id"
  end

  create_table "weight_entries", :force => true do |t|
    t.integer  "weight"
    t.string   "unit"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
  end

end
