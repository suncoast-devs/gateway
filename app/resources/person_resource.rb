class PersonResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :full_name, :string
  attribute :email_address, :string
  attribute :phone_number, :string
  attribute :crm_identifier, :string
  attribute :crm_url, :string
  attribute :source, :string
  attribute :ac_contact_identifier, :string
  attribute :preferred_communication, :string
  attribute :shirt_size, :string
  attribute :dietary_note, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
