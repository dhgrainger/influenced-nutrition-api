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

ActiveRecord::Schema[8.1].define(version: 2025_12_19_225449) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "influencer_profiles", force: :cascade do |t|
    t.text "bio"
    t.decimal "commission_rate", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.integer "follower_count"
    t.string "instagram_handle"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["instagram_handle"], name: "index_influencer_profiles_on_instagram_handle"
    t.index ["user_id"], name: "index_influencer_profiles_on_user_id"
  end

  create_table "subscriber_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "dietary_preferences"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_subscriber_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "instagram_token"
    t.string "instagram_username"
    t.string "name", null: false
    t.string "password_digest"
    t.string "provider"
    t.datetime "token_expires_at"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["instagram_username"], name: "index_users_on_instagram_username"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["user_type"], name: "index_users_on_user_type"
  end

  add_foreign_key "influencer_profiles", "users"
  add_foreign_key "subscriber_profiles", "users"
end
