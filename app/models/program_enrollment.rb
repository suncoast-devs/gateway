class ProgramEnrollment < ApplicationRecord
  belongs_to :person
  belongs_to :cohort, optional: true

  enum status: {active: 0, won: 1, lost: 2}
  enum stage: {applied: 3, interviewing: 4, accepted: 5, enrolled: 6}
end
