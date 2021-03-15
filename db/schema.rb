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

ActiveRecord::Schema.define(version: 2021_03_15_030935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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

  create_table "calendar_events", force: :cascade do |t|
    t.bigint "person_id"
    t.string "name"
    t.string "uuid"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean "is_canceled"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_calendar_events_on_person_id"
  end

  create_table "cohorts", force: :cascade do |t|
    t.string "name"
    t.boolean "is_enrolling", default: false
    t.date "begins_on"
    t.date "ends_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "format"
    t.string "note"
    t.string "delivery"
  end

  create_table "communication_templates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "title"
    t.string "body"
    t.string "key"
    t.integer "media", default: 0, null: false
    t.boolean "is_system", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_communication_templates_on_user_id"
  end

  create_table "communications", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "user_id"
    t.integer "media", default: 0, null: false
    t.boolean "is_unread", default: true, null: false
    t.text "subject"
    t.text "body"
    t.jsonb "data", default: "{}", null: false
    t.datetime "messaged_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "direction", default: 0, null: false
    t.index ["person_id"], name: "index_communications_on_person_id"
    t.index ["user_id"], name: "index_communications_on_user_id"
  end

  create_table "contact_dispositions", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "user_id"
    t.integer "code", default: 0, null: false
    t.datetime "contacted_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_contact_dispositions_on_person_id"
    t.index ["user_id"], name: "index_contact_dispositions_on_user_id"
  end

  create_table "course_registrations", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "course_id"
    t.bigint "invoice_id"
    t.integer "fee"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_registrations_on_course_id"
    t.index ["invoice_id"], name: "index_course_registrations_on_invoice_id"
    t.index ["person_id"], name: "index_course_registrations_on_person_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.string "session"
    t.date "starts_on"
    t.date "ends_on"
    t.string "days"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "user_id"
    t.string "label"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_documents_on_person_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "instigator_id"
    t.string "name"
    t.jsonb "payload", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["instigator_id"], name: "index_events_on_instigator_id"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "description"
    t.integer "quantity"
    t.decimal "amount", precision: 8, scale: 2
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
    t.jsonb "data", default: "{}", null: false
    t.text "note_type"
    t.bigint "notable_id"
    t.string "close_note"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_notes_on_discarded_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "acknowledged_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_notifications_on_event_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
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
    t.string "ac_contact_identifier"
    t.string "preferred_communication"
    t.string "shirt_size"
    t.string "dietary_note"
    t.string "given_name"
    t.string "family_name"
    t.string "middle_name"
    t.string "client_ip_address"
    t.bigint "last_contact_disposition_id"
    t.bigint "last_communication_id"
    t.string "close_lead"
    t.string "close_contact"
    t.datetime "discarded_at"
    t.bigint "merged_person_id"
    t.index ["discarded_at"], name: "index_people_on_discarded_at"
    t.index ["last_communication_id"], name: "index_people_on_last_communication_id"
    t.index ["last_contact_disposition_id"], name: "index_people_on_last_contact_disposition_id"
    t.index ["merged_person_id"], name: "index_people_on_merged_person_id"
  end

  create_table "program_acceptances", force: :cascade do |t|
    t.bigint "cohort_id"
    t.integer "tuition_reduction", default: 0, null: false
    t.string "enrollment_agreement_url"
    t.text "notification_body"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_id"
    t.bigint "program_enrollment_id"
    t.string "enrollment_agreement_identifier"
    t.boolean "is_rescinded", default: false
    t.datetime "discarded_at"
    t.index ["cohort_id"], name: "index_program_acceptances_on_cohort_id"
    t.index ["discarded_at"], name: "index_program_acceptances_on_discarded_at"
    t.index ["program_enrollment_id"], name: "index_program_acceptances_on_program_enrollment_id"
  end

  create_table "program_applications", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "question_responses", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "program"
    t.integer "application_status", default: 0
    t.boolean "is_hidden", default: false
    t.bigint "person_id"
    t.bigint "program_enrollment_id"
    t.string "continue_url"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_program_applications_on_discarded_at"
    t.index ["person_id"], name: "index_program_applications_on_person_id"
    t.index ["program_enrollment_id"], name: "index_program_applications_on_program_enrollment_id"
  end

  create_table "program_enrollments", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "cohort_id"
    t.string "program"
    t.string "ac_deal_identifier"
    t.integer "stage", default: 3, null: false
    t.integer "status", default: 0, null: false
    t.boolean "deposit_required", default: true
    t.boolean "deposit_paid"
    t.boolean "enrollment_agreement_complete"
    t.string "financial_clearance"
    t.string "lost_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "referrer"
    t.bigint "deposit_invoice_id"
    t.string "ac_deposit_outstanding_field"
    t.string "ac_sea_signed_field"
    t.string "ac_financially_cleared_field"
    t.string "ac_deposit_invoice_url_field"
    t.string "ac_sea_sign_url_field"
    t.string "ac_cohort_start_date_field"
    t.string "ac_cohort_name_field"
    t.uuid "status_locator", default: -> { "public.gen_random_uuid()" }, null: false
    t.string "ac_student_status_url_field"
    t.string "student_status_url"
    t.boolean "academic_signoff"
    t.boolean "administrative_signoff"
    t.string "close_opportunity"
    t.datetime "discarded_at"
    t.index ["cohort_id"], name: "index_program_enrollments_on_cohort_id"
    t.index ["deposit_invoice_id"], name: "index_program_enrollments_on_deposit_invoice_id"
    t.index ["discarded_at"], name: "index_program_enrollments_on_discarded_at"
    t.index ["person_id"], name: "index_program_enrollments_on_person_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_type", "taggable_id"], name: "index_taggings_on_tag_id_and_taggable_type_and_taggable_id", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_notifiable", default: false, null: false
    t.string "close_user"
  end

  create_table "webhook_events", force: :cascade do |t|
    t.string "name"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "calendar_events", "people"
  add_foreign_key "communication_templates", "users"
  add_foreign_key "communications", "people"
  add_foreign_key "communications", "users"
  add_foreign_key "contact_dispositions", "people"
  add_foreign_key "contact_dispositions", "users"
  add_foreign_key "course_registrations", "courses"
  add_foreign_key "course_registrations", "invoices"
  add_foreign_key "course_registrations", "people"
  add_foreign_key "documents", "people"
  add_foreign_key "documents", "users"
  add_foreign_key "events", "users", column: "instigator_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "people"
  add_foreign_key "notes", "users"
  add_foreign_key "notifications", "events"
  add_foreign_key "notifications", "users"
  add_foreign_key "people", "communications", column: "last_communication_id"
  add_foreign_key "people", "contact_dispositions", column: "last_contact_disposition_id"
  add_foreign_key "people", "people", column: "merged_person_id"
  add_foreign_key "program_acceptances", "cohorts"
  add_foreign_key "program_applications", "people"
  add_foreign_key "program_enrollments", "cohorts"
  add_foreign_key "program_enrollments", "invoices", column: "deposit_invoice_id"
  add_foreign_key "program_enrollments", "people"
  add_foreign_key "taggings", "tags"
end
