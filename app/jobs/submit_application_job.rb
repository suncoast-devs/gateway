# frozen_string_literal: true

# Async worker for submitting completed program application.
class SubmitApplicationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # SubmitApplication.call(*args) if Rails.env.production?
  end
end
