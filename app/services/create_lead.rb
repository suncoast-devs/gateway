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

  def initialize(email, given_name, family_name, source, note)
    @nutshell = Nutshell.client
    @email = email
    @given_name = given_name
    @family_name = family_name
    @source = source
    @note = note
  end

  def call
    find_lead || create_lead
    if @source == "mailing_list"
      mailchimp = Mailchimp::API.new(Rails.application.credentials.mailchimp_api_key)
      mailchimp.lists.subscribe("ee85c9fa69",
                                { email: @email },
                                { FNAME: @given_name, LNAME: @family_name },
                                'html')
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
    sources = SOURCES[@source] ? [{id: SOURCES[@source]}] : []
    @nutshell.new_lead(contacts: [{id: contact["id"]}],
                       sources: sources,
                       note: ["Created via lead capture hook.", @note].compact)
  end
end
