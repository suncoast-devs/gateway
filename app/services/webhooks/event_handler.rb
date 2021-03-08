module Webhooks
  class EventHandler
    include Callable

    HANDLERS = {
      "calendly" => Calendly,
      "esignatures" => Esignatures,
    }

    def initialize(webhook_event)
      @service = HANDLERS[webhook_event.name.to_sym]
      raise "Unhandled Webhook: #{webhook_event.name}" unless @service
      @payload = webhook_event.payload.with_indifferent_access
    end

    def call
      @service.call(@payload)
    end
  end
end
