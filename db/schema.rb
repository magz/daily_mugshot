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

ActiveRecord::Schema.define(:version => 20120207220538) do

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "email_reminders", :force => true do |t|
    t.integer  "authuser_id"
    t.integer  "hour"
    t.boolean  "active"
    t.datetime "deleted_at"
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

  create_table "landmarks", :force => true do |t|
    t.integer  "authuser_id"
    t.integer  "xcoord"
    t.integer  "ycoord"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mugshots", :force => true do |t|
    t.integer  "authuser_id"
    t.string   "caption"
    t.integer  "xoffset"
    t.integer  "yoffset"
    t.boolean  "active"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "updated_at"
    t.string   "image_content_type"
    t.boolean  "transfer_error"
    t.string   "filename"
    t.datetime "deleted_at"
    t.datetime "created_at"
  end

  create_table "old_mugshots", :force => true do |t|
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

  create_table "reminders", :force => true do |t|
    t.integer  "authuser_id"
    t.string   "platform"
    t.string   "version"
    t.string   "release_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
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
