class EventHandler
  include Callable

  def initialize(name, payload, instigator = nil)
    @event = Event.new(name: name, payload: payload, instigator: instigator)
  end

  def call
    if @event.save!
      User.notifiable.where.not(id: @event.instigator&.id).each do |user|
        notification = user.notifications.create!(event: @event)
        DeliverNotification.call_later(notification.id)
      end
    end
  end
end
