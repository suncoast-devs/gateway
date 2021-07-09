class Cohort < ApplicationRecord
  scope :enrolling, -> { where(is_enrolling: true).order(begins_on: :asc) }
  has_many :program_enrollments

  def display_name
    "Cohort #{name}"
  end

  def alt_display_name
    if name == "Future"
      display_name
    else
      "#{name} (#{begins_on ? begins_on.strftime("%B %Y") : "TBD"})"
    end
  end

  def tuition_due_date
    days_before = (begins_on.wday + 1) % 5 + 1
    begins_on - days_before
  end

  def to_liquid
    CohortDrop.new(self)
  end

  def self.enrolling_and_future
    enrolling.or(where(name: 'Future'))
  end
end
