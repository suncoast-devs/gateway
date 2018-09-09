# frozen_string_literal: true

# Provides a service for creating a new program application
class LocateCRMIdentifier
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
    @nutshell = Nutshell.client
  end

  def call
    @program_application.update! crm_identifier: lead_id
  end

  private

  def contact_id
    @contact_id ||= begin
      contact = @nutshell.search_by_email(@program_application.email_address)['contacts'].first ||
                @nutshell.new_contact(name: @program_application.full_name,
                                      email: [@program_application.email_address],
                                      phone: [@program_application.phone_number])
      contact['id']
    end
  end

  def lead_id
    @lead_id ||= begin
      lead = @nutshell.get_contact(contact_id)['leads'].last ||
             @nutshell.new_lead(contacts: [{ id: contact_id }],
                                products: [{ id: 1 }],
                                note: ['Created via program application form.'])
      lead['id']
    end
  end
end
