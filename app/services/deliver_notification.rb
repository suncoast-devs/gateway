# frozen_string_literal: true
class DeliverNotification
  include Callable

  def initialize(notification)
    @notification = notification
  end

  # TODO: Slack notifications, etc.
  def call
    UserMailer.with(notification: @notification).notification_email.deliver_later unless @notification.acknowledged_at
  end
end
