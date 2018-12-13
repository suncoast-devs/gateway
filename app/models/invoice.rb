class Invoice < ApplicationRecord
  belongs_to :person
  has_many :invoice_items
  has_many :notes, as: :notable
  accepts_nested_attributes_for :invoice_items
  validates :due_on, presence: true
end
