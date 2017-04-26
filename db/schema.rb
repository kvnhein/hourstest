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

ActiveRecord::Schema.define(version: 20170426112126) do

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
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "beer_status"
    t.integer  "beer_level"
    t.string   "serving_size"
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

  create_table "claims", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "description"
    t.integer  "status"
    t.date     "delete_date"
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
  end

  add_index "claims", ["cached_votes_down"], name: "index_claims_on_cached_votes_down", using: :btree
  add_index "claims", ["cached_votes_score"], name: "index_claims_on_cached_votes_score", using: :btree
  add_index "claims", ["cached_votes_total"], name: "index_claims_on_cached_votes_total", using: :btree
  add_index "claims", ["cached_votes_up"], name: "index_claims_on_cached_votes_up", using: :btree
  add_index "claims", ["cached_weighted_average"], name: "index_claims_on_cached_weighted_average", using: :btree
  add_index "claims", ["cached_weighted_score"], name: "index_claims_on_cached_weighted_score", using: :btree
  add_index "claims", ["cached_weighted_total"], name: "index_claims_on_cached_weighted_total", using: :btree
  add_index "claims", ["event_id"], name: "index_claims_on_event_id", using: :btree
  add_index "claims", ["user_id"], name: "index_claims_on_user_id", using: :btree

  create_table "daily_specials", force: :cascade do |t|
    t.string   "text"
    t.text     "description"
    t.string   "price"
    t.integer  "venue_id"
    t.string   "dish_type"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "status"
    t.string   "dish_status"
    t.float    "start"
    t.float    "end"
    t.string   "day"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "credit"
    t.integer  "available_credits"
    t.date     "special_date"
    t.integer  "user_id"
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
  end

  add_index "daily_specials", ["cached_votes_down"], name: "index_daily_specials_on_cached_votes_down", using: :btree
  add_index "daily_specials", ["cached_votes_score"], name: "index_daily_specials_on_cached_votes_score", using: :btree
  add_index "daily_specials", ["cached_votes_total"], name: "index_daily_specials_on_cached_votes_total", using: :btree
  add_index "daily_specials", ["cached_votes_up"], name: "index_daily_specials_on_cached_votes_up", using: :btree
  add_index "daily_specials", ["cached_weighted_average"], name: "index_daily_specials_on_cached_weighted_average", using: :btree
  add_index "daily_specials", ["cached_weighted_score"], name: "index_daily_specials_on_cached_weighted_score", using: :btree
  add_index "daily_specials", ["cached_weighted_total"], name: "index_daily_specials_on_cached_weighted_total", using: :btree
  add_index "daily_specials", ["venue_id"], name: "index_daily_specials_on_venue_id", using: :btree

  create_table "drink_lists", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "venue_id"
  end

  add_index "drink_lists", ["venue_id"], name: "index_drink_lists_on_venue_id", using: :btree

  create_table "drinks", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.text     "description"
    t.string   "price"
    t.string   "drink_Status"
    t.string   "drink_type"
    t.integer  "venue_id"
    t.integer  "spr"
  end

  add_index "drinks", ["venue_id"], name: "index_drinks_on_venue_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.text     "special"
    t.string   "day"
    t.integer  "venue_id"
    t.float    "start"
    t.float    "end"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "detail"
    t.datetime "event_verify"
    t.integer  "varified_user"
    t.integer  "user_id"
    t.integer  "status",                  default: 0
    t.date     "event_date"
    t.boolean  "food"
    t.boolean  "drinks"
    t.boolean  "late_nite"
    t.boolean  "entertainment"
    t.boolean  "legit_hour"
    t.integer  "cached_votes_total",      default: 0
    t.integer  "cached_votes_score",      default: 0
    t.integer  "cached_votes_up",         default: 0
    t.integer  "cached_votes_down",       default: 0
    t.integer  "cached_weighted_score",   default: 0
    t.integer  "cached_weighted_total",   default: 0
    t.float    "cached_weighted_average", default: 0.0
    t.integer  "credits"
  end

  add_index "events", ["cached_votes_down"], name: "index_events_on_cached_votes_down", using: :btree
  add_index "events", ["cached_votes_score"], name: "index_events_on_cached_votes_score", using: :btree
  add_index "events", ["cached_votes_total"], name: "index_events_on_cached_votes_total", using: :btree
  add_index "events", ["cached_votes_up"], name: "index_events_on_cached_votes_up", using: :btree
  add_index "events", ["cached_weighted_average"], name: "index_events_on_cached_weighted_average", using: :btree
  add_index "events", ["cached_weighted_score"], name: "index_events_on_cached_weighted_score", using: :btree
  add_index "events", ["cached_weighted_total"], name: "index_events_on_cached_weighted_total", using: :btree
  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "likes", force: :cascade do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "liqours", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "distillery"
    t.string   "liqour_status"
    t.string   "liqour_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "price"
    t.integer  "venue_id"
  end

  add_index "liqours", ["venue_id"], name: "index_liqours_on_venue_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "brew_id"
    t.string   "serving_style"
    t.string   "serving_size"
    t.string   "price"
    t.string   "status"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "brew_level",       default: true
    t.boolean  "brew_special",     default: true
    t.string   "draft_Status"
    t.string   "beer_name"
    t.text     "beer_description"
    t.string   "beer_abv"
  end

  add_index "lists", ["brew_id"], name: "index_lists_on_brew_id", using: :btree
  add_index "lists", ["venue_id"], name: "index_lists_on_venue_id", using: :btree

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "daily_special_id"
    t.integer  "credit"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "reservations", ["daily_special_id"], name: "index_reservations_on_daily_special_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context", using: :btree
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "todos", force: :cascade do |t|
    t.string   "title"
    t.text     "notes"
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
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.string   "fullname"
    t.string   "school"
    t.integer  "experience"
    t.boolean  "email_reminder"
    t.integer  "num_verified"
    t.integer  "num_event_votes"
    t.integer  "num_claim_votes"
    t.integer  "num_events_saved"
    t.integer  "num_features_liked"
    t.boolean  "feature_rights"
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
    t.string   "genre"
    t.boolean  "urbanist"
    t.integer  "avg_verify"
    t.string   "open_table_id"
    t.integer  "spr_rank"
  end

  add_index "venues", ["neighborhood_id"], name: "index_venues_on_neighborhood_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "claims", "events"
  add_foreign_key "claims", "users"
  add_foreign_key "daily_specials", "venues"
  add_foreign_key "drink_lists", "venues"
  add_foreign_key "drinks", "venues"
  add_foreign_key "events", "venues"
  add_foreign_key "liqours", "venues"
  add_foreign_key "lists", "brews"
  add_foreign_key "lists", "venues"
  add_foreign_key "reservations", "daily_specials"
  add_foreign_key "reservations", "users"
  add_foreign_key "venues", "neighborhoods"
end
