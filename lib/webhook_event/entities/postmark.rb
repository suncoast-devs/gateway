# frozen_string_literal: true
module WebhookEvent
  module Entities

    # Postmark Event
    class Postmark
      def initialize(payload)
        @payload = payload
      end
    end
  end
end
