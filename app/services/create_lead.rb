# frozen_string_literal: true

# Provides a service for creating generic leads
class CreateLead
  include Callable

  SOURCES = {
    "mailing_list": 208,
    "catalog": 212,
    "tour_rsvp": 216,
    "demo_day": 220,
  }

  def initialize(email, given_name, family_name, source)
    @nutshell = Nutshell.client
    @email = email
    @given_name = given_name
    @given_name = family_name
    @source = source
  end

  def call
    find_lead || create_lead
    if @source == "mailing_list"
      mailchimp = Mailchimp::API.new(Rails.application.credentials.mailchimp_api_key)
      mailchimp.lists.subscribe("ee85c9fa69", { email: @email }, 'html',
        {
          FNAME: @given_name,
          LNAME: @family_name
        }
      )
    end
  end

  private

  def contact
    @contact ||= begin
      @nutshell.search_by_email(@email)["contacts"].first ||
        @nutshell.new_contact(name: {
                                givenName: @given_name,
                                familyName: @family_name,
                              },
                              email: @email)
    end
  end

  def find_lead
    lead_stub = @nutshell.get_contact(contact["id"])["leads"].last
    lead_stub ? @nutshell.get_lead(lead_stub["id"]) : nil
  end

  def create_lead
    @nutshell.new_lead(contacts: [{id: contact["id"]}],
                       sources: [{id: SOURCES[@source]}],
                       note: ["Created via lead capture hook."])
  end
end
