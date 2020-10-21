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
      person.given_name = params[:given_name]
      person.middle_name = params[:middle_name]
      person.family_name = params[:family_name]
      person.client_ip_address = request.remote_ip
      person.source = "Web Development Program Application"
    end
    @program_application = @person.program_applications.create! create_params    
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

    if update_params[:application_status] == 'complete' && @program_application.program == "web-development"
      PostLeadToVerity.call_later(@program_application.person.id)
      publish_event :complete_application, @program_application
    end
    render json: {ok: true}
  end

  def continue
    @program_application = ProgramApplication.find params[:id]

    render json: {
      token: @program_application.id,
      responses: @program_application.question_responses,
      contact: {given_name: @program_application.person.given_name,
                middle_name: @program_application.person.middle_name,
                family_name: @program_application.person.family_name,
                email_address: @program_application.person.email_address,
                phone_number: @program_application.person.phone_number},
    }
  end

  private

  def contact_params
    params.slice(:given_name, :family_name, :middle_name, :email_address, :phone_number).permit!
  end

  def create_params
    params.slice(:program, :question_responses, :application_status).permit!
  end

  def update_params
    params.slice(:question_responses, :application_status).permit!
  end
end
