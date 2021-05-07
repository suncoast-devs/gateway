# frozen_string_literal: true

module WebhookEvent
  class Repository < ROM::Repository[:webhook_events]
    include Import[container: 'persistence']

    commands :create, update: :by_pk

    def by_id(id)
      webhook_events.by_pk(id).one!
    end
  end
end
