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

ActiveRecord::Schema.define(:version => 20100323225345) do

  create_table "admins", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.text     "text",                           :null => false
    t.string   "url",                            :null => false
    t.string   "title",                          :null => false
    t.string   "keywords"
    t.string   "description"
    t.string   "formatting"
    t.string   "category"
    t.boolean  "published",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["id", "published", "url"], :name => "index_pages_on_url_and_id_and_published"

  create_table "submissions", :force => true do |t|
    t.string   "video_url"
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.text     "text"
    t.float    "lat"
    t.float    "lng"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "featured"
    t.string   "title"
  end

  create_table "sumbissions", :force => true do |t|
    t.string   "video_url"
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.text     "text"
    t.float    "lat"
    t.float    "lng"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
