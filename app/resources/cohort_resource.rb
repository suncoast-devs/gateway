class CohortResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :name, :string
  attribute :is_enrolling, :boolean
  attribute :begins_on, :date
  attribute :ends_on, :date

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
