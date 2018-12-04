# frozen_string_literal: true

# Provides public API for program applications
class ApplyController < ApplicationController
  before_action :honey_pot
  skip_before_action :verify_authenticity_token

  # POST /apply
  # {
  #   "full_name": "Dave Jones",
  #   "email_address": "dave@example.com",
  #   "phone_number": "(727) 555-1234"
  # }
  def create
    @program_application = ProgramApplication.create! create_params
    LocateCRMIdentifierJob.perform_later(@program_application.id)
    SubmitApplicationJob.perform_later(@program_application.id) unless @program_application.question_responses.empty?
    render json: { id: @program_application.id }
  end

  # PATCH /apply/:idea
  # {
  #   "question_responses": {
  #     "What color is the sky?": "Blue!"
  #   }
  # }
  def update
    @program_application = ProgramApplication.find params[:id]
    puts(update_params)
    @program_application.update update_params
    SubmitApplicationJob.perform_later(@program_application.id)
    render json: { ok: true }
  end

  private

  def create_params
    params.slice(:full_name, :email_address, :phone_number, :program, :question_responses).permit!
  end

  def update_params
    params.slice(:question_responses).permit!
  end
end
