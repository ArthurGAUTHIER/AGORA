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

ActiveRecord::Schema.define(version: 2018_08_31_102958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "directors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "libraries", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "already_watched", default: false
    t.boolean "watch_later", default: false
    t.boolean "blacklist", default: false
    t.index ["medium_id"], name: "index_libraries_on_medium_id"
    t.index ["user_id"], name: "index_libraries_on_user_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "title"
    t.string "poster"
    t.string "trailer"
    t.string "synopsys"
    t.integer "duration"
    t.integer "year"
    t.string "country"
    t.float "press_rating"
    t.float "audience_rating"
    t.string "netflix_link"
    t.string "amazon_link"
    t.string "language"
    t.bigint "studio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["studio_id"], name: "index_media_on_studio_id"
  end

  create_table "media_actors", force: :cascade do |t|
    t.bigint "medium_id"
    t.bigint "actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_media_actors_on_actor_id"
    t.index ["medium_id"], name: "index_media_actors_on_medium_id"
  end

  create_table "media_categories", force: :cascade do |t|
    t.bigint "medium_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_media_categories_on_category_id"
    t.index ["medium_id"], name: "index_media_categories_on_medium_id"
  end

  create_table "media_directors", force: :cascade do |t|
    t.bigint "medium_id"
    t.bigint "director_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["director_id"], name: "index_media_directors_on_director_id"
    t.index ["medium_id"], name: "index_media_directors_on_medium_id"
  end

  create_table "media_moods", force: :cascade do |t|
    t.bigint "medium_id"
    t.bigint "mood_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_media_moods_on_medium_id"
    t.index ["mood_id"], name: "index_media_moods_on_mood_id"
  end

  create_table "moods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "medium_id"
    t.bigint "user_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_reviews_on_medium_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "studios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alias"
    t.string "photo"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "libraries", "media"
  add_foreign_key "libraries", "users"
  add_foreign_key "media", "studios"
  add_foreign_key "media_actors", "actors"
  add_foreign_key "media_actors", "media"
  add_foreign_key "media_categories", "categories"
  add_foreign_key "media_categories", "media"
  add_foreign_key "media_directors", "directors"
  add_foreign_key "media_directors", "media"
  add_foreign_key "media_moods", "media"
  add_foreign_key "media_moods", "moods"
  add_foreign_key "reviews", "media"
  add_foreign_key "reviews", "users"
end
