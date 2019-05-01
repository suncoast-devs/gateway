class InvoiceItemResource < ApplicationResource
  attribute :id, :integer, writable: false

  attribute :invoice_id, :integer

  attribute :description, :string
  attribute :quantity, :integer
  attribute :amount, :float

  attribute :created_at, :datetime, writable: false
  attribute :updated_at, :datetime, writable: false
end
