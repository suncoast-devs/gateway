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
    @person = Person.where("lower(email_address) = ?", params[:email_address].downcase).first_or_create do |person|
      person.email_address = params[:email_address]
      person.phone_number = params[:phone_number]
      person.full_name = params[:full_name]
      person.source = "#{params[:program].parameterize}-program-application"
    end
    @program_application = @person.program_applications.create! create_params
    ConnectPersonToActiveCampaign.call_later(@person.id)
    @program_application.update(application_status: :complete) unless @program_application.question_responses.empty?
    render json: {id: @program_application.id}
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
    CreateProgramEnrollment.call(@program_application.id)
    render json: {ok: true}
  end

  private

  def create_params
    params.slice(:program, :question_responses).permit!
  end

  def update_params
    params.slice(:question_responses).permit!
  end
end
