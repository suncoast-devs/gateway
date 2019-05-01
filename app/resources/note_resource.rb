class NoteResource < ApplicationResource
  attribute :id, :integer, writable: false
  attribute :user_id, :integer
  attribute :notable_id, :integer
  attribute :notable_type, :string

  attribute :message, :string
  attribute :data, :hash
  attribute :note_type, :string

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
