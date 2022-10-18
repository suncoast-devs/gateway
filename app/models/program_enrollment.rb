# frozen_string_literal: true
class ProgramEnrollment < ApplicationRecord
  include Discard::Model
  belongs_to :person
  belongs_to :cohort, optional: true
  belongs_to :deposit_invoice, class_name: 'Invoice', optional: true
  has_many :program_applications
  has_many :program_acceptances

  enum stage: {
         canceled: 0,
         prospecting: 2,
         applied: 3,
         interviewing: 4,
         accepted: 5,
         rejected: 9,
         enrolling: 7,
         enrolled: 6,
         graduated: 10,
         dropped: 8,
         incomplete: 11,
       }

  def active?
    !(cancelled? || rejected? || dropped? || incomplete?)
  end

  def current_program_acceptance
    program_acceptances.active.order(created_at: :desc).first
  end

  def deposit_unpaid_and_required?
    deposit_required? && !deposit_paid? && deposit_invoice.present?
  end

  def to_liquid
    ProgramEnrollmentDrop.new(self)
  end
end
