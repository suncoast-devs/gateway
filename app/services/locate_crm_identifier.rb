# frozen_string_literal: true

# Provides a service for creating a new program application
class LocateCRMIdentifier
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
    @nutshell = Nutshell.client
  end

  def call
    @program_application.update! crm_identifier: lead['id'], crm_url: lead['htmlUrl']
  end

  private

  def contact
    @contact ||= begin
      @nutshell.search_by_email(@program_application.email_address)['contacts'].first ||
        @nutshell.new_contact(name: @program_application.full_name,
                              email: [@program_application.email_address],
                              phone: [@program_application.phone_number])
    end
  end

  def lead
    @lead ||= find_lead || create_lead
  end

  def find_lead
    lead_stub = @nutshell.get_contact(contact['id'])['leads'].last
    lead_stub ? @nutshell.get_lead(lead_stub['id']) : nil
  end

  def create_lead
    @nutshell.new_lead(contacts: [{ id: contact['id'] }],
                       products: [{ id: 4 }],
                       note: ['Created via program application form.'])
  end
end
