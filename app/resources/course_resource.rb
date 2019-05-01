class CourseResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :identifier, :string
  attribute :name, :string
  attribute :session, :string
  attribute :starts_on, :date
  attribute :ends_on, :date
  attribute :days, :string
  attribute :time, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
