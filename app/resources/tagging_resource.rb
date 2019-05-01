class TaggingResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :tag_id, :integer
  attribute :taggable_type, :string
  attribute :taggable_id, :integer

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
