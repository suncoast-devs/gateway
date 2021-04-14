module Enrollment
  extend self

  def configure(event_store, command_bus)
    event_store.subscribe(ApplicationProjection, to: [Application::Submitted])
    command_bus.register(Application::Submit, Application::Submit::Handler.new)
  end
end
