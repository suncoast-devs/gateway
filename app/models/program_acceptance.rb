class ProgramAcceptance < ApplicationRecord
  belongs_to :cohort
  belongs_to :program_enrollment

  delegate :person, to: :program_enrollment
end
