# frozen_string_literal: true
class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  validates :description, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :amount, presence: true
end
