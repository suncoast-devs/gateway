class ProgramApplicationResource < ApplicationResource
  attribute :id, :uuid, writable: false

  attribute :person_id, :integer
  attribute :program_enrollment_id, :integer

  attribute :question_responses, :hash
  attribute :program, :string
  attribute :application_status, :integer
  attribute :is_hidden, :boolean
  attribute :continue_url, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
