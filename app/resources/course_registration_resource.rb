class CourseRegistrationResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :person_id, :integer
  attribute :course_id, :integer
  attribute :invoice_id, :integer

  attribute :fee, :integer
  attribute :code, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
