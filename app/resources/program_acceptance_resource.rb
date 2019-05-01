class ProgramAcceptanceResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :cohort_id, :integer
  attribute :program_enrollment_id, :integer

  attribute :tuition_reduction, :integer
  attribute :enrollment_agreement_url, :string
  attribute :notification_body, :string
  attribute :sent_at, :datetime
  attribute :message_id, :string
  attribute :enrollment_agreement_identifier, :string
  attribute :is_rescinded, :boolean

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
