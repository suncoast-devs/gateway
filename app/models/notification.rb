# frozen_string_literal: true
class Notification < ApplicationRecord
  belongs_to :event
  belongs_to :user

  def acknowledge!
    update acknowledged_at: Time.zone.now
  end
end
