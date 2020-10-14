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

ActiveRecord::Schema.define(version: 2020_10_13_200242) do

  create_table "accounts", force: :cascade do |t|
    t.integer "account_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "account_status_date"
    t.integer "conversation_status"
    t.string "stripe_customer_id"
    t.string "stripe_payment_method"
    t.string "stripe_payment_method_card_country"
    t.string "residence_country"
    t.string "vat_country"
    t.integer "user_id"
    t.datetime "stripe_payment_method_expiry_reminder"
    t.integer "total_support"
    t.string "invoice_account_name"
    t.string "invoice_account_address"
    t.string "invoice_account_tax_id"
  end

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
    t.boolean "is_breaking"
    t.integer "language_id"
    t.integer "original_id"
    t.integer "frame_id"
    t.integer "main_id"
    t.integer "story_id"
    t.string "image"
    t.string "audio_file_mp3"
    t.string "audio_intro"
    t.string "video"
    t.string "extras_audio_file"
    t.string "extras_audio_intro"
    t.text "extras_notes"
    t.string "alertmessage"
    t.string "extras_notes_teaser"
    t.string "extras_audio_teaser"
    t.string "extras_transcription_file"
    t.string "extras_transcription_intro"
    t.string "extras_transcription_teaser"
    t.string "short_headline"
    t.text "audio_episode_notes"
    t.integer "audio_file_mp3_length"
    t.string "audio_file_mp3_type"
    t.integer "audio_file_episode"
    t.integer "audio_file_duration"
    t.string "audio_file_aac"
    t.integer "audio_file_aac_length"
    t.string "audio_file_aac_type"
    t.integer "upload_id"
    t.index ["frame_id"], name: "index_articles_on_frame_id"
    t.index ["language_id"], name: "index_articles_on_language_id"
    t.index ["main_id"], name: "index_articles_on_main_id"
    t.index ["original_id"], name: "index_articles_on_original_id"
    t.index ["story_id"], name: "index_articles_on_story_id"
  end

  create_table "articles_statuses", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "status_id"
  end

  create_table "articles_types", id: false, force: :cascade do |t|
    t.integer "article_id"
    t.integer "type_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "article_id"
    t.integer "user_id"
    t.boolean "new_email_reader_article"
    t.boolean "first_subscription_article"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "frame_id"
    t.string "article_headline"
    t.string "frame_emotional_quest_action"
  end

  create_table "countries", force: :cascade do |t|
    t.string "country_code"
    t.string "name_en"
    t.string "name_es"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "tax_percent", precision: 5, scale: 3
  end

  create_table "frames", force: :cascade do |t|
    t.text "short_story"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "emotional_quest_action"
    t.integer "original_id"
    t.string "button_cta"
    t.string "image"
    t.text "social_proof"
    t.text "risk_reversal"
    t.string "emotional_quest_role"
    t.string "link_slug"
    t.string "money_word_singular"
    t.string "money_word_plural"
    t.string "money_word_verb"
    t.string "access_patrons_only"
    t.string "access_more_for_patrons"
    t.string "cta_patron_active_middle"
    t.string "cta_patron_active_top"
    t.string "email_reader_header"
    t.string "email_reader_text"
    t.string "email_reader_placeholder"
    t.string "email_reader_button"
    t.string "cta_reader_to_patron"
    t.string "cta_patron_active_bottom"
    t.string "cta_patron_paused"
    t.string "cta_patron_cancelled"
    t.string "cta_reader_to_patron_link"
    t.string "cta_patron_active_bottom_link"
    t.string "cta_patron_active_middle_link"
    t.string "cta_patron_active_top_link"
    t.string "cta_patron_paused_link"
    t.string "cta_patron_cancelled_link"
    t.index ["language_id"], name: "index_frames_on_language_id"
    t.index ["original_id"], name: "index_frames_on_original_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal "tax_percent"
    t.integer "plan_amount"
    t.integer "tax_amount"
    t.integer "total_amount"
    t.integer "account_id"
    t.integer "subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_year"
    t.integer "invoice_month"
    t.integer "invoice_day"
    t.string "invoice_number"
    t.string "invoice_customer_address"
    t.string "invoice_customer_tax_id"
    t.string "invoice_customer_name"
    t.string "invoice_concept"
    t.string "invoice_from_name"
    t.string "invoice_from_address"
    t.string "invoice_from_tax_id"
    t.integer "invoice_status"
    t.string "invoice_tax_country"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prompt"
  end

  create_table "payment_errors", force: :cascade do |t|
    t.integer "payment_id"
    t.string "payment_error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_error_source"
    t.string "payment_error_status"
    t.string "payment_error_code"
    t.string "payment_error_object"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_country"
    t.integer "total_amount"
    t.integer "account_id"
    t.integer "invoice_id"
    t.integer "subscription_id"
    t.string "payment_method"
    t.string "external_payment_id"
    t.string "external_payment_status"
    t.string "external_payment_error"
  end

  create_table "plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "image"
    t.integer "price"
    t.string "description"
    t.string "buttontext"
    t.string "link"
    t.integer "original_id"
    t.integer "language_id"
    t.index ["language_id"], name: "index_plans_on_language_id"
    t.index ["original_id"], name: "index_plans_on_original_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "colorbackground"
    t.string "colortext"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "plan_amount"
    t.string "card_country"
    t.datetime "last_payment_date"
    t.string "ip_country"
    t.string "ip_address"
    t.string "residence_country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "vat_rate"
    t.integer "vat_amount"
    t.integer "total_amount"
    t.integer "frame_id"
    t.string "vat_country"
    t.string "frame_link_slug"
    t.integer "article_id"
    t.string "frame_emotional_quest_action"
    t.string "frame_button_cta"
    t.string "referrer_url"
    t.datetime "next_payment_date"
    t.string "frame_money_word_singular"
    t.text "motivation_general_environment"
    t.text "motivation_specific_brand"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "previous_id"
    t.integer "twitter_tweet_id", limit: 8
    t.string "image"
    t.integer "article_id"
    t.string "quicktranslation"
    t.integer "upload_id"
    t.string "tweet_url"
    t.index ["article_id"], name: "index_tweets_on_article_id"
    t.index ["previous_id"], name: "index_tweets_on_previous_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.string "name_plural"
    t.index ["language_id"], name: "index_types_on_language_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "file_size"
    t.string "file_type"
    t.integer "main_id"
    t.integer "version"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.boolean "email_confirmed"
    t.string "password_digest"
    t.integer "status"
    t.string "confirm_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "emails"
    t.integer "emaillanguage"
    t.integer "sitelanguage"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer "account_id"
    t.integer "account_role"
    t.string "address"
    t.integer "level_amount"
    t.integer "frame_id"
    t.boolean "can_read"
    t.datetime "can_read_date"
    t.integer "country_id"
  end

  create_table "webhook_events", force: :cascade do |t|
    t.string "source"
    t.string "external_id"
    t.json "data"
    t.integer "state", default: 0
    t.text "processing_errors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_webhook_events_on_external_id"
    t.index ["source"], name: "index_webhook_events_on_source"
  end

end
