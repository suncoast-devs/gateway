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
      @person = Person.where("lower(email_address) = ?", params[:email_address].downcase).first_or_create do |person|
        person.email_address = params[:email_address]
        person.phone_number = params[:phone_number]
        person.given_name = params[:given_name]
        person.middle_name = params[:middle_name]
        person.family_name = params[:family_name]
        person.client_ip_address = request.remote_ip
        person.source = "Course Registration"
      end
      CreateCourseRegistration.call_later(@person.id, params[:course], params[:code])
      render json: {ok: true}
    end
  end
end
