# frozen_string_literal: true

require 'rom-repository'

class WebhookEventRepository < ROM::Repository[:webhook_events]
  commands :create, update: :by_pk

  def by_id(id)
    webhook_events.by_pk(id).one!
  end
end
