# frozen_string_literal: true
class EventHandler
  include Callable

  def initialize(name, payload, instigator = nil)
    @event = Event.new(name: name, payload: payload, instigator: instigator)
  end

  def call
    if @event.save! && @event.is_notifiable?
      User
        .notifiable
        .where.not(id: @event.instigator&.id)
        .each do |user|
          notification = user.notifications.create!(event: @event)
          DeliverNotification.call_in(1.minute, notification)
        end
    end
  end
end
