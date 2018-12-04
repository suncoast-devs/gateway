# frozen_string_literal: true

# Async worker for creating a generic lead.
class CreateLeadJob < ApplicationJob
  queue_as :default

  def perform(*args)
    CreateLead.call(*args) if Rails.env.production?
  end
end
