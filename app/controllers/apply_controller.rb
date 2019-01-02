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
    @person = Person.find_or_create_by(email_address: params[:email_address]) do |person|
      person.phone_number = params[:phone_number]
      person.full_name = params[:full_name]
      person.source = "#{params[:program].parameterize}-program-application"
    end
    @program_application = @person.program_applications.create! create_params
    SyncCrmsJob.perform_later(@person.id)
    LocateCRMIdentifierJob.perform_later(@person.id, @program_application.id)
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
    params.slice(:program, :question_responses).permit!
  end

  def update_params
    params.slice(:question_responses).permit!
  end
end
