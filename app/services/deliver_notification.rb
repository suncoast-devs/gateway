class DeliverNotification
  include Callable

  def initialize(notification_id)
    @notification = Notification.find notification_id
  end

  # TODO: Slack notifications, etc.
  def call
    unless @notification.acknowledged_at
      UserMailer.with(notification: @notification).notification_email.deliver_later
    end
  end
end
