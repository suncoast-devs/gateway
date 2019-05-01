class ProgramEnrollmentResource < ApplicationResource
  attribute :id, :integer, writable: false
  attribute :person_id, :integer
  attribute :cohort_id, :integer
  attribute :program, :string
  attribute :ac_deal_identifier, :string
  attribute :stage, :integer
  attribute :status, :integer
  attribute :deposit_required, :boolean
  attribute :deposit_paid, :boolean
  attribute :enrollment_agreement_complete, :boolean
  attribute :financial_clearance, :string
  attribute :lost_reason, :string
  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
  attribute :referrer, :string
  attribute :deposit_invoice_id, :integer
  attribute :ac_deposit_outstanding_field, :string
  attribute :ac_sea_signed_field, :string
  attribute :ac_financially_cleared_field, :string
  attribute :ac_deposit_invoice_url_field, :string
  attribute :ac_sea_sign_url_field, :string
  attribute :ac_cohort_start_date_field, :string
  attribute :ac_cohort_name_field, :string
  attribute :status_locator, :uuid
  attribute :ac_student_status_url_field, :string
  attribute :student_status_url, :string
  attribute :academic_signoff, :boolean
  attribute :administrative_signoff, :boolean
end
