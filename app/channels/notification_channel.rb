class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def acknowledge(data)
    Notification.find(data["id"]).acknowledge!
  end
end
