module WebhookEvent
  class Controller
    include Import['webhook_event.repository']

    def call(env)
      [200, {}, []]
    end
  end
end
