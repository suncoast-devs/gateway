class ProjectionJob < ApplicationJob
  prepend RailsEventStore::AsyncHandler

  def perform(event)
    send event.class.name.demodulize.underscore, event
  end
end
