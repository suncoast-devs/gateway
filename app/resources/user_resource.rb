class UserResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :uid, :string
  attribute :name, :string
  attribute :email, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
