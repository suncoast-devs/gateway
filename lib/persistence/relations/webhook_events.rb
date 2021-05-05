# frozen_string_literal: true

module Persistence
  module Relations
    class WebhookEvents < ROM::Relation[:sql]
      schema :webhook_events, infer: true
    end
  end
end
