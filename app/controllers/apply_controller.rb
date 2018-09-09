# frozen_string_literal: true

# Provides public API for program applications
class ApplyController < ApplicationController
  respond_to :json

  # POST /apply
  # {
  #   "full_name": "Dave Jones",
  #   "email_address": "dave@example.com",
  #   "phone_number": "(727) 555-1234"
  # }
  def create
    service = NewApplicationService.new(params)
    respond json: { id: service.perform.id }
  end

  # PATCH /apply/:idea
  # {
  #   "qa": [
  #     {
  #       "q": "What color is the sky?",
  #       "a": "!"
  #     }
  #   ]
  # }
  def update
    SubmitApplication.new(params).perform
    respond json: { ok: true }
  end
end
