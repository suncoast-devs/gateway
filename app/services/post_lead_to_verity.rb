# frozen_string_literal: true

# Provides a service for connecting a Person in Gateway to Verity
class PostLeadToVerity
  CREDENTIALS = Rails.application.credentials[Rails.env.to_sym][:verity]
  API_ENDPOINT = "https://api.verityiq.com/api/LeadPost"

  include Callable

  def initialize(person_id)
    @person = Person.find(person_id)
  end

  def call
    return unless Rails.env.production?

    given_name, family_name = FullNameSplitter.split(@person.full_name)

    params = {
      "veritySysKey" => CREDENTIALS[:sys_key],
      "tenantid" => CREDENTIALS[:tenant_id],
      "leadid" => "GW-#{@person.id}",
      "campaigncode" => "St. Petersburg",
      "campaigntype" => "St. Petersburg",
      "fname" => @person.given_name,
      "lname" => @person.family_name,
      "mname" => @person.middle_name,
      "phone" => @person.phone_number,
      "email" => @person.email_address,
      "zip" => "",
      "ipaddr" => @person.client_ip_address,
      "consent" => "Yes",
      "sms" => "Yes",
      "schoolname" => "Suncoast Developers Guild",
      "campus" => "St. Petersburg",
      "program" => "Web Development",
      "leadsource" => @person.source&.titleize || ""
    }

    HTTP.post(API_ENDPOINT, form: params)
  end
end
