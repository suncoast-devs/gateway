# frozen_string_literal: true

# Provides a service for creating generic leads
class CreateLead
  include Callable

  SOURCES = {
    "mailing-list" => 208,
    "catalog" => 212,
    "tour-rsvp" => 216,
    "demo-day" => 220,
  }

  def initialize(email, given_name, family_name, source, phone, note)
    @email = email
    @given_name = given_name
    @family_name = family_name
    @source = source
    @phone = phone
    @note = note

    @person = Person.where("lower(email_address) = ?", email.downcase).first_or_initialize do |person|
      person.full_name ||= [given_name, family_name].join(" ")
      person.phone_number ||= phone
      person.source ||= source.parameterize
      person.save!
    end
  end

  def call
    return unless Rails.env.production?
    ConnectPersonToActiveCampaign.call_later @person.id
    PostLeadToVerity.call_later @person.id

    mailchimp = Mailchimp::API.new(Rails.application.credentials.mailchimp_api_key)

    if @source == "mailing-list"
      mailchimp.lists.subscribe("ee85c9fa69",
                                {email: @email},
                                {FNAME: @given_name, LNAME: @family_name},
                                "html")
    end

    if @source == "community"
      @mailchimp.lists.subscribe("3d4e0699f1",
                                 {email: @email_address},
                                 {FNAME: @given_name, LNAME: @family_name},
                                 "html")
    end
  end
end
