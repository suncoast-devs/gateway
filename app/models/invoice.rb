class Invoice < ApplicationRecord
  belongs_to :person
  has_many :invoice_items
  accepts_nested_attributes_for :invoice_items
end
