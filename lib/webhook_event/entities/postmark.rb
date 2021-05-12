module WebhookEvent
  module Entities
    class Postmark
      def initialize(payload)
        @payload = payload
      end
    end
  end
end
