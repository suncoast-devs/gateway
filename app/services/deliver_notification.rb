class DeliverNotification
  include Callable

  def initialize(notification_id)
    @notification = Notification.find notification_id
  end

  # TODO: Slack notifications, etc.
  def call
    UserMailer.with(notification: @notification).notification_email.deliver_later
  end
end
