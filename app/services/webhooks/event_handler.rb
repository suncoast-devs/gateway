module Webhooks
  class EventHandler
    include Callable

    HANDLERS = {
      "calendly" => Calendly,
      "esignatures" => Esignatures,
      "postmark" => Postmark,
      "stripe" => Stripe,
    }

    def initialize(webhook_event)
      @service = HANDLERS[webhook_event.name]
      raise "Unhandled Webhook: #{webhook_event.name}" unless @service
      @payload = webhook_event.payload.with_indifferent_access
    end

    def call
      @service.call(@payload)
    end
  end
end
