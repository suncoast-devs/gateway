# frozen_string_literal: true
class CalendarEvent < ApplicationRecord
  belongs_to :person, optional: true

  scope :upcoming, -> { where('starts_at > ?', 6.hours.ago.beginning_of_day).order(starts_at: :asc).limit(20) }

end
