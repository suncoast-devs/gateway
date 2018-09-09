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
    @program_application = ProgramApplication.create! params
    LocateCRMIdentifierJob.perform_async(@program_application.id)
    respond json: { id: @program_application.id }
  end

  # PATCH /apply/:idea
  # {
  #   "question_responses": [
  #     {
  #       "q": "What color is the sky?",
  #       "a": "!"
  #     }
  #   ]
  # }
  def update
    @program_application = ProgramApplication.find @params[:id]
    @program_application.update update_params
    SubmitApplicationJob.perform_async(@program_application.id)
    respond json: { ok: true }
  end

  private

  def create_params
    params.permit(:full_name, :email_address, :phone_number)
  end

  def update_params
    params.permit(:question_responses)
  end
end
