# frozen_string_literal: true

# Async worker for locating CRM identifier for a program application.
class LocateCrmIdentifierJob < ApplicationJob
  queue_as :default

  def perform(*args)
    LocateCrmIdentifier.call(*args)
  end
end
