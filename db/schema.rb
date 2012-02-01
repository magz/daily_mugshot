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

ActiveRecord::Schema.define(:version => 20120131213139) do

  create_table "authusers", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.boolean  "active"
    t.string   "time_zone"
    t.string   "gender"
    t.date     "birthday"
    t.boolean  "prvt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "deleted_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "authuser_id"
    t.integer  "mugshot_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "authuser_id"
    t.string   "email"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "authuser_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mugshots", :force => true do |t|
    t.integer  "authuser_id"
    t.string   "caption"
    t.integer  "xoffset"
    t.integer  "yoffset"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.datetime "image_updated_at"
    t.datetime "deleted_at"
  end

  create_table "transferred_mugshots", :id => false, :force => true do |t|
    t.integer  "id",                 :default => 0, :null => false
    t.integer  "authuser_id"
    t.datetime "created_at"
    t.integer  "xoffset"
    t.integer  "yoffset"
    t.datetime "deleted_at"
    t.boolean  "active"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "caption"
    t.datetime "updated_at"
    t.string   "image_content_type"
    t.boolean  "transfer_error"
  end

  create_table "twitter_connects", :force => true do |t|
    t.integer  "authuser_id"
    t.string   "token"
    t.string   "secret"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.integer  "authuser_id"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
