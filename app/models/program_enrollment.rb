class ProgramEnrollment < ApplicationRecord
  belongs_to :person
  belongs_to :cohort, optional: true
  belongs_to :deposit_invoice, class_name: "Invoice", optional: true
  has_many :program_applications
  has_many :program_acceptances

  enum status: {active: 0, won: 1, lost: 2, cancelled: 3, pending: 4}
  enum stage: {applied: 3, interviewing: 4, accepted: 5, enrolling: 7, enrolled: 6}

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
