# frozen_string_literal: true

# Provides a service for connecting a Person in Gateway to ActiveCampaign
class ConnectProgramApplicationToActiveCampaign
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
  end

  def call
    @program_application.update ac_deal_identifier: deal['id'] unless @program_application.ac_deal_identifier
  end

  private

  def deal
    @deal ||= begin
      person = @program_application.person
      ActiveCampaign.post('deals',
                          deal: {
                            contact: person.ac_contact_identifier,
                            currency: 'usd',
                            group: '1', # Web Development Program
                            stage: '3', # Applied
                            status: 0,
                            title: person.full_name,
                            value: 14_900 * 100
                          })['deal']
    end
  end
end
