# frozen_string_literal: true
class LedgerEntry < ApplicationRecord
  belongs_to :person
  belongs_to :invoice, optional: true
end
