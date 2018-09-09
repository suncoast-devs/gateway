# frozen_string_literal: true

# Async worker for submitting completed program application.
class UpdateSignoffJob < ApplicationJob
  queue_as :default

  def perform(*args)
    UpdateSignoff.call(*args)
  end
end
