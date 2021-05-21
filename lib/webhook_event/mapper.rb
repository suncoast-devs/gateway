# frozen_string_literal: true
module WebhookEvent

  # Map Webhook event entities
  class Mapper < ROM::Transformer
    relation :webhook_events, as: :event_mapper

    map do
      resolve_model
      create_instance
    end

    def resolve_model(row)
      entity = Inflector.classify(row[:name].gsub!(/[^A-Za-z]/, ''))
      ["WebhookEvent::Entities::#{entity}", row]
    end

    def create_instance(model, row)
      model.new(row[:payload])
    end
  end
end
