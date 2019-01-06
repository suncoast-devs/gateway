# frozen_string_literal: true

# Provides a service for connecting a Person in Gateway to ActiveCampaign
class ConnectPersonToActiveCampaign
  include Callable

  def initialize(person_id)
    @person = Person.find(person_id)
  end

  def call
    return unless Rails.env.production?
    @person.update ac_contact_identifier: contact["id"] if contact
  end

  private

  def contact
    @contact ||= begin
      first_name, last_name = FullNameSplitter.split(@person.full_name)
      ActiveCampaign.post("contact/sync",
                          contact: {
                            firstName: first_name,
                            lastName: last_name,
                            email: @person.email_address,
                            phone: @person.phone_number,
                          })["contact"]
    end
  end
end
