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
    @program_application.update update_params
    @program_application.person.update(contact_params)
    CreateProgramEnrollment.call(@program_application.id) if @program_application.application_complete?
    render json: {ok: true}
  end

  def continue
    @program_application = ProgramApplication.find params[:id]

    render json: {
      token: @program_application.id,
      responses: @program_application.question_responses,
      contact: {full_name: @program_application.person.full_name,
                email_address: @program_application.person.email_address,
                phone_number: @program_application.person.phone_number},
    }
  end

  private

  def contact_params
    params.slice(:full_name, :email_address, :phone_number).permit!
  end

  def create_params
    params.slice(:program, :question_responses, :application_status).permit!
  end

  def update_params
    params.slice(:question_responses, :application_status).permit!
  end
end
