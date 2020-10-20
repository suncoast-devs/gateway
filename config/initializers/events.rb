ActiveSupport::Notifications.subscribe /gateway/ do |name, *args|
  payload = args.extract_options!
  instigator = payload.delete(:current_user)
  EventHandler.call(name, payload, instigator)
end
