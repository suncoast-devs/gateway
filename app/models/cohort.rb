class Cohort < ApplicationRecord
  scope :enrolling, -> { where(is_enrolling: true).order(begins_on: :asc) }
  has_many :program_enrollments

  def display_name
    "Cohort #{name}"
  end

  def alt_display_name
    "#{name} (#{begins_on ? begins_on.strftime("%B %Y") : "TBD"})"
  end

  def tuition_due_date
    days_before = (begins_on.wday + 1) % 5 + 1
    begins_on - days_before
  end

  def to_liquid
    CohortDrop.new(self)
  end
end
