class Cohort < ApplicationRecord
  scope :enrolling, -> { where(is_enrolling: true).order(begins_on: :asc) }

  def display_name
    "#{name} (#{begins_on ? begins_on.strftime("%B %Y") : "TBD"})"
  end
end
