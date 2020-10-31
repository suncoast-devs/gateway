class Notification < ApplicationRecord
  belongs_to :event
  belongs_to :user

  after_create :broadcast

  def broadcast
    NotificationChannel.broadcast_to user, {
      id: id,
      event: {
        name: event.name,
        title: event.title,
        message: event.message,
        link: event.link_url,
      },
    }
  end

  def acknowledge!
    update acknowledged_at: Time.now
  end
end
