# frozen_string_literal: true

# Background job for Async execution of service workers.
class AsyncServiceJob < ApplicationJob
  queue_as :default

  def perform(service, *args)
    klass = Object.const_get service
    klass.call(*args)
  end
end
