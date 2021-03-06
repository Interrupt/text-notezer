# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090403144522) do

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "type"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notebooks", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shared_public"
  end

  create_table "notes", :force => true do |t|
    t.string   "note"
    t.integer  "user_id"
    t.integer  "notebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tagged_notes", :force => true do |t|
    t.integer "note_id"
    t.integer "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "notebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.string   "email"
    t.string   "sms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
