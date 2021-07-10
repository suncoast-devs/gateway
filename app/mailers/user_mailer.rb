# frozen_string_literal: true
class UserMailer < ApplicationMailer

  def notification_email
    @notification = params[:notification]
    @event = @notification.event
    @user = @notification.user

    mail to: "#{@user.name} <#{@user.email}>", subject: "Gateway: #{@event.title}"
  end
end
