# frozen_string_literal: true
class WebhookEvent < ApplicationRecord
  def display_event
    case name
    when 'close'
      [payload.dig('event', 'object_type'), payload.dig('event', 'action')].join('/')
    when 'calendly'
      payload['event']
    when 'postmark'
      payload['record_type']
    end
  end
end
