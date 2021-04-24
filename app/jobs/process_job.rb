class ProcessJob < ApplicationJob
  prepend RailsEventStore::AsyncHandler
end
