# frozen_string_literal: true
module API
  class RegistrationController < ApplicationController
    skip_before_action :verify_authenticity_token

    # POST /api/registration
    # {
    #   "name": "Dave Jones",
    #   "email": "dave@example.com",
    #   "phone": "(727) 555-1234",
    #   "course": "wdtd",
    #   "code": ""
    # }
    def create
      @person = Person.where('lower(email_address) = ?', params[:email_address].downcase).first_or_create do |person|
        person.email_address = params[:email_address]
        person.phone_number = params[:phone_number]
        person.given_name = params[:given_name]
        person.middle_name = params[:middle_name]
        person.family_name = params[:family_name]
        person.client_ip_address = request.remote_ip
        person.source = 'Course Registration'
      end
      @course = Course.where(identifier: params[:course]).where('starts_on > ?', Date.today).first
      @course_registration = @person.course_registrations.create(course: @course, code: params[:code])
      
      CreateCourseRegistrationInvoice.call_later(@course_registration)
      publish_event :course_registration, @course_registration
      
      render json: {ok: true}
    end
  end
end
