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

ActiveRecord::Schema.define(version: 2018_12_14_041805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "cohorts", force: :cascade do |t|
    t.string "name"
    t.boolean "is_enrolling", default: false
    t.date "begins_on"
    t.date "ends_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "description"
    t.integer "quantity"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "person_id"
    t.date "due_on"
    t.string "stripe_id"
    t.string "payment_url"
    t.boolean "is_paid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_invoices_on_person_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "notable_type"
    t.bigint "user_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "notable_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "full_name"
    t.string "email_address"
    t.string "phone_number"
    t.string "crm_identifier"
    t.string "crm_url"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "program_acceptances", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "cohort_id"
    t.integer "tuition_reduction", default: 0, null: false
    t.text "notification_body"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_program_acceptances_on_cohort_id"
    t.index ["person_id"], name: "index_program_acceptances_on_person_id"
  end

  create_table "program_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "academic_signoff"
    t.boolean "administrative_signoff"
    t.json "question_responses", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "program"
    t.integer "application_status", default: 0
    t.integer "interview_status", default: 0
    t.integer "acceptance_status", default: 0
    t.boolean "is_hidden", default: false
    t.bigint "person_id"
    t.index ["person_id"], name: "index_program_applications_on_person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "people"
  add_foreign_key "notes", "users"
  add_foreign_key "program_acceptances", "cohorts"
  add_foreign_key "program_acceptances", "people"
  add_foreign_key "program_applications", "people"
end
