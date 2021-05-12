# frozen_string_literal: true

module WebhookEvent
  # Sidekiq Worker for processing webhook events
  class Worker
    include Sidekiq::Worker

    def perform(*args)
      # Do work here
    end
  end
end
