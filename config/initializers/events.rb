ActiveSupport::Notifications.subscribe /gateway/ do |name, *args|
  payload, instigator = args.last
  EventHandler.call(name, payload, instigator)
end
