# frozen_string_literal: true

# The ProgramApplication model represents a potential student's
# application to the Academy.
class ProgramApplication < ApplicationRecord
  belongs_to :person
  has_many :notes, as: :notable

  scope :visible, -> { where(is_hidden: false) }
  scope :hidden, -> { where(is_hidden: true) }

  enum application_status: %i[incomplete complete], _prefix: 'application'
  enum interview_status: %i[pending scheduled skipped], _prefix: 'interview'
  enum acceptance_status: %i[unsent sent rejected], _prefix: 'acceptance'
end
