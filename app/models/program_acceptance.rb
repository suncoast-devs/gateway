class ProgramAcceptance < ApplicationRecord
  belongs_to :person
  belongs_to :cohort
  belongs_to :program_enrollment
  belongs_to :program_application
  belongs_to :deposit_invoice, class_name: "Invoice", optional: true
end
