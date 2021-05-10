# frozen_string_literal: true

module WebhookEvent
  # Rack app to handle webhook events.
  class Controller
    include Import['webhook_event.repository']

    def call(env)
      request = Rack::Request.new(env)
      if request.post?
        name = request.path_info.scan(%r{/hooks/(.+)}).last
        repository.create({ name: name, payload: request.body.string, received_at: Time.now })
        [200, {}, []]
      else
        [405, {}, []]
      end
    end
  end
end
