# frozen_string_literal: true

# Async worker for locating CRM identifier for a program application.
class LocateCRMIdentifierJob < ApplicationJob
  queue_as :default

  def perform(*args)
    LocateCrmIdentifier.call(*args) if Rails.env.production?
  end
end
