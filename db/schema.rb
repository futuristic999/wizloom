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

ActiveRecord::Schema.define(:version => 20120223153329) do

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
  end

  add_index "entries", ["fieldvalues_id"], :name => "index_entries_on_fieldvalues_id"
  add_index "entries", ["template_id"], :name => "index_entries_on_template_id"

  create_table "field_values", :force => true do |t|
    t.integer  "entry_id"
    t.string   "label"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "weight_entries", :force => true do |t|
    t.integer  "weight"
    t.string   "unit"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
  end

end
