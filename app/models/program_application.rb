class ProgramApplication < ApplicationRecord
  has_many :notes, as: :notable
end
