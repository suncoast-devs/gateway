# frozen_string_literal: true

# The ProgramApplication model represents a potential student's
# application to the Academy.
class ProgramApplication < ApplicationRecord
  has_many :notes, as: :notable

  scope :visible, -> { where(is_hidden: false) }
  scope :hidden, -> { where(is_hidden: true) }

  enum application_status: [:incomplete, :complete], _prefix: 'application'
  enum interview_status: [:pending, :scheduled, :skipped], _prefix: 'interview'
  enum acceptance_status: [:unsent, :sent, :rejected], _prefix: 'acceptance'

end
