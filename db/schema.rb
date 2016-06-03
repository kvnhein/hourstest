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

ActiveRecord::Schema.define(version: 20160603182524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beers", force: :cascade do |t|
    t.string   "name"
    t.string   "brewery"
    t.string   "abv"
    t.string   "genre"
    t.string   "price"
    t.string   "serving"
    t.text     "details"
    t.integer  "venue_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "beer_status"
  end

  add_index "beers", ["venue_id"], name: "index_beers_on_venue_id", using: :btree

  create_table "brews", force: :cascade do |t|
    t.string   "name"
    t.string   "brewery"
    t.text     "detail"
    t.string   "abv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "style"
  end

  create_table "events", force: :cascade do |t|
    t.text     "special"
    t.string   "day"
    t.integer  "venue_id"
    t.float    "start"
    t.float    "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "detail"
  end

  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "brew_id"
    t.string   "serving_style"
    t.string   "serving_size"
    t.string   "price"
    t.string   "status"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "brew_level",    default: true
    t.boolean  "brew_special",  default: true
  end

  add_index "lists", ["brew_id"], name: "index_lists_on_brew_id", using: :btree
  add_index "lists", ["venue_id"], name: "index_lists_on_venue_id", using: :btree

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "neighborhood_id"
    t.integer  "owner"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "menu_address"
    t.string   "phone_number"
    t.datetime "venue_verify"
  end

  add_index "venues", ["neighborhood_id"], name: "index_venues_on_neighborhood_id", using: :btree

  add_foreign_key "events", "venues"
  add_foreign_key "lists", "brews"
  add_foreign_key "lists", "venues"
  add_foreign_key "venues", "neighborhoods"
end
