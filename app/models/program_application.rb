# frozen_string_literal: true

# The ProgramApplication model represents a potential student's
# application to the Academy.
class ProgramApplication < ApplicationRecord
  has_many :notes, as: :notable
end
