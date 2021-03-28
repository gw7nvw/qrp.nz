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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210328074356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_settings", force: true do |t|
    t.string   "qrpnz_email"
    t.string   "admin_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_log_baselines", force: true do |t|
    t.integer  "contest_id"
    t.string   "callsign"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contest_log_entries", force: true do |t|
    t.string   "time"
    t.string   "callsign"
    t.boolean  "is_qrp"
    t.boolean  "is_portable"
    t.boolean  "is_dx"
    t.string   "mode"
    t.string   "name"
    t.string   "location"
    t.float    "frequency"
    t.integer  "rst_sent"
    t.integer  "index_sent"
    t.integer  "rst_recd"
    t.integer  "index_recd"
    t.integer  "contest_log_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calc_points"
    t.string   "band"
    t.integer  "rownum"
    t.boolean  "is_valid"
    t.integer  "validated_against"
    t.boolean  "time_valid"
    t.boolean  "callsign_valid"
    t.boolean  "qrp_valid"
    t.boolean  "portable_valid"
    t.boolean  "dx_valid"
    t.boolean  "mode_valid"
    t.boolean  "name_valid"
    t.boolean  "location_valid"
    t.boolean  "frequency_valid"
    t.boolean  "rst_sent_valid"
    t.boolean  "index_sent_valid"
    t.boolean  "rst_recd_valid"
    t.boolean  "index_recd_valid"
    t.boolean  "band_valid"
    t.boolean  "is_backcountry"
    t.boolean  "backcountry_valid"
  end

  create_table "contest_logs", force: true do |t|
    t.string   "callsign"
    t.string   "fullname"
    t.string   "location"
    t.integer  "contest_id"
    t.datetime "date"
    t.string   "power"
    t.string   "antenna"
    t.integer  "hut_id"
    t.integer  "park_id"
    t.integer  "island_id"
    t.boolean  "is_qrp"
    t.boolean  "is_portable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_backcountry"
  end

  create_table "contest_series", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "include_qrp"
    t.boolean  "include_portable"
    t.boolean  "include_qth"
    t.boolean  "include_rst"
    t.boolean  "include_index"
    t.boolean  "include_freq"
    t.boolean  "members_only"
    t.boolean  "is_active"
    t.integer  "createdBy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "base_points"
    t.integer  "qrp_points"
    t.integer  "portable_points"
    t.integer  "cw_points"
    t.integer  "dx_points"
    t.string   "minreqs"
    t.string   "log_url"
    t.string   "xls_log_url"
    t.string   "odt_log_url"
    t.boolean  "include_backcountry"
    t.integer  "backcountry_points"
    t.integer  "valid_points"
    t.boolean  "include_valid"
    t.boolean  "score_per_hour"
  end

  create_table "contests", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "contest_series_id"
    t.boolean  "is_active"
    t.integer  "createdBy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname"
  end

  create_table "hota_posts", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "filename"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
  end

  create_table "items", force: true do |t|
    t.integer  "topic_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "do_not_publish"
    t.datetime "referenced_datetime"
    t.datetime "referenced_date"
    t.datetime "referenced_time"
    t.integer  "duration"
    t.string   "site"
    t.string   "code"
    t.string   "mode"
    t.string   "freq"
    t.boolean  "is_hut"
    t.boolean  "is_park"
    t.boolean  "is_island"
    t.boolean  "is_summit"
    t.string   "hut"
    t.string   "park"
    t.string   "island"
    t.string   "summit"
    t.string   "callsign"
  end

  create_table "qrpnzmembers", force: true do |t|
    t.integer  "user_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timezones", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "difference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "owner_id"
    t.boolean  "is_public"
    t.boolean  "is_owners"
    t.datetime "last_updated"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_members_only"
    t.boolean  "date_required"
    t.boolean  "allow_mail"
    t.boolean  "duration_required"
    t.boolean  "is_alert"
    t.boolean  "is_spot"
  end

  create_table "uploadedfiles", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "filename"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "filetype"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
  end

  create_table "uploads", force: true do |t|
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "doc_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_topic_links", force: true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.boolean  "mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "callsign"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "activation_digest"
    t.boolean  "activated",            default: false
    t.datetime "activated_at"
    t.boolean  "is_admin",             default: false
    t.boolean  "is_active",            default: true
    t.boolean  "is_modifier",          default: false
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "membership_requested"
    t.boolean  "membership_confirmed"
    t.string   "home_qth"
    t.string   "mailuser"
    t.boolean  "group_admin"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
