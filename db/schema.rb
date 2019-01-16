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

ActiveRecord::Schema.define(version: 2019_01_16_134251) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "headline"
    t.string "lede"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_id"
    t.integer "status_id"
    t.boolean "topstory"
    t.boolean "is_free"
    t.integer "language_id"
    t.integer "original_id"
    t.integer "campaign_id"
    t.integer "main_id"
    t.index ["campaign_id"], name: "index_articles_on_campaign_id"
    t.index ["language_id"], name: "index_articles_on_language_id"
    t.index ["main_id"], name: "index_articles_on_main_id"
    t.index ["original_id"], name: "index_articles_on_original_id"
  end

  create_table "articles_statuses", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "status_id"
  end

  create_table "articles_stories", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "story_id"
  end

  create_table "articles_types", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "type_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.text "teaser"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "original_id"
    t.string "buttontext"
    t.index ["language_id"], name: "index_campaigns_on_language_id"
    t.index ["original_id"], name: "index_campaigns_on_original_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prompt"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "lede"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.integer "status_id"
    t.integer "original_id"
    t.index ["language_id"], name: "index_stories_on_language_id"
    t.index ["original_id"], name: "index_stories_on_original_id"
    t.index ["status_id"], name: "index_stories_on_status_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.index ["language_id"], name: "index_types_on_language_id"
  end

end
