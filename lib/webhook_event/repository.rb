# frozen_string_literal: true

require 'rom-repository'

module WebhookEvent
  class Repository < ROM::Repository[:webhook_events]
    include Application.import[container: 'persistence']

    commands :create, update: :by_pk

    def by_id(id)
      webhook_events.by_pk(id).one!
    end
  end
end
