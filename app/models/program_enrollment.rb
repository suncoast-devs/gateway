class ProgramEnrollment < ApplicationRecord
  belongs_to :person
  belongs_to :cohort, optional: true
  belongs_to :deposit_invoice, class_name: "Invoice", optional: true
  has_many :program_applications
  has_many :program_acceptances

  enum status: {active: 0, won: 1, lost: 2, cancelled: 3, pending: 4}
  enum stage: {applied: 3, interviewing: 4, accepted: 5, enrolled: 6}
end
