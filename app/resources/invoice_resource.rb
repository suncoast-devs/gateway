class InvoiceResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :person_id, :integer

  attribute :due_on, :date
  attribute :stripe_id, :string
  attribute :payment_url, :string
  attribute :is_paid, :boolean

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
