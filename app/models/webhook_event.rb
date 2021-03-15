class WebhookEvent < ApplicationRecord
  def display_event
    case name
    when "close"
      [payload.dig("event", "object_type"), payload.dig("event", "action")].join("/")
    when "calendly"
      payload.dig("event")
    end
  end
end
