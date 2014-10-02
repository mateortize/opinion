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

ActiveRecord::Schema.define(version: 20141002151148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "email",                    default: "",   null: false
    t.string   "encrypted_password",       default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.integer  "plan_id",                  default: 1
    t.string   "promotion_code",           default: "f"
    t.string   "language",                 default: "en"
    t.text     "info"
    t.integer  "status",                   default: 1
    t.string   "avatar_image"
    t.integer  "biao_account_id"
    t.integer  "referrer_baio_account_id"
    t.string   "referrer_code"
  end

  add_index "accounts", ["biao_account_id"], name: "index_accounts_on_biao_account_id", using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["plan_id"], name: "index_accounts_on_plan_id", using: :btree
  add_index "accounts", ["referrer_baio_account_id"], name: "index_accounts_on_referrer_baio_account_id", using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "addresses", force: true do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id"], name: "index_addresses_on_addressable_id", using: :btree
  add_index "addresses", ["addressable_type"], name: "index_addresses_on_addressable_type", using: :btree

  create_table "answer_translations", force: true do |t|
    t.integer  "answer_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text"
  end

  add_index "answer_translations", ["answer_id"], name: "index_answer_translations_on_answer_id", using: :btree
  add_index "answer_translations", ["locale"], name: "index_answer_translations_on_locale", using: :btree

  create_table "answers", force: true do |t|
    t.string   "text"
    t.integer  "submission_count", default: 0
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "row",              default: 0
    t.string   "image"
    t.integer  "position"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.integer  "price_cents",             default: 0
    t.integer  "status",                  default: 1
    t.integer  "duration",                default: 1
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maximum_surveys_count"
    t.integer  "maximum_languages_count"
    t.integer  "position"
    t.string   "image"
  end

  add_index "plans", ["status"], name: "index_plans_on_status", using: :btree

  create_table "question_translations", force: true do |t|
    t.integer  "question_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text"
    t.text     "description"
  end

  add_index "question_translations", ["locale"], name: "index_question_translations_on_locale", using: :btree
  add_index "question_translations", ["question_id"], name: "index_question_translations_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "text"
    t.text     "description"
    t.integer  "survey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_type"
    t.integer  "rows",          default: 1
    t.string   "image"
    t.integer  "position"
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "submission_logs", force: true do |t|
    t.integer  "submission_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: true do |t|
    t.string   "ip_address"
    t.integer  "survey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "account_id"
    t.integer  "plan_id"
    t.string   "payment_method", default: "inatec"
    t.string   "token"
    t.text     "info"
    t.integer  "tax_cents",      default: 0
    t.integer  "total_cents",    default: 0
    t.integer  "subtotal_cents", default: 0
    t.string   "transaction_id"
    t.string   "invoice_file"
    t.string   "card_brand"
    t.string   "last_4_digits"
    t.date     "expired_at"
    t.integer  "status",         default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",           default: false
  end

  add_index "subscriptions", ["account_id"], name: "index_subscriptions_on_account_id", using: :btree
  add_index "subscriptions", ["payment_method"], name: "index_subscriptions_on_payment_method", using: :btree
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["status"], name: "index_subscriptions_on_status", using: :btree
  add_index "subscriptions", ["token"], name: "index_subscriptions_on_token", using: :btree

  create_table "survey_translations", force: true do |t|
    t.integer  "survey_id",   null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
  end

  add_index "survey_translations", ["locale"], name: "index_survey_translations_on_locale", using: :btree
  add_index "survey_translations", ["survey_id"], name: "index_survey_translations_on_survey_id", using: :btree

  create_table "surveys", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "enabled"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "submission_count", default: 0
    t.string   "logo"
    t.string   "locales"
  end

  add_index "surveys", ["account_id"], name: "index_surveys_on_account_id", using: :btree

end
