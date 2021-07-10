# frozen_string_literal: true
module Close
  module Webhooks
    module_function

    def subscribe
      events = []
      %w[lead contact opportunity activity.note].each do |object_type|
        %w[created updated deleted].each do |action|
          events << {
            object_type: object_type,
            action: action,
          }
        end
      end
      events << { object_type: 'lead', action: 'merged' }
      Close::API.post('webhook', 
{ url: Rails.application.routes.url_helpers.api_webhooks_url('close'), events: events })
    end

    def unsubscribe
      webhooks = Close::API.get('webhook')
      webhooks['data'].each do |webhook|
        if webhook['url'] == Rails.application.routes.url_helpers.api_webhooks_url('close')
          webhooks = Close::API.delete("webhook/#{webhook['id']}")
        end
      end
    end
  end
end
