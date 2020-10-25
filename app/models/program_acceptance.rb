class ProgramAcceptance < ApplicationRecord
  belongs_to :cohort
  belongs_to :program_enrollment

  delegate :person, to: :program_enrollment

  scope :active, -> { where(is_rescinded: false) }

  def to_liquid
    ProgramAcceptanceDrop.new(self)
  end
end
