class TagResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :name, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
