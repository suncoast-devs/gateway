class NewApplicationService

  attr_reader :params, :nutshell, :program_application, :contact_id, :lead_id

  def initialize(params)
    @params = params.slice(:full_name, :email_address, :phone_number)
    @nutshell = Nutshell.client
  end

  def perform
    create_program_application
    find_or_create_contact
    find_or_create_lead
    link_crm_identifier
  end

  private

  def create_program_application
    @program_application = ProgramApplication.create! params
  end

  def link_crm_identifier
    program_application.update_attribute! :crm_identifier, lead_id
  end

  def find_or_create_contact
    contact = nutshell.search_by_email(params[:email_address])["contacts"].first
    if contact
      @contact_id = contact["id"]
    else
      new_contact = nutshell.new_contact({
        name: params[:full_name],
        email: [params[:email_address]],
        phone: [@params[:phone_number]]
      })
      @contact_id = new_contact["id"]
    end
  end

  def find_or_create_lead
    lead = nutshell.get_contact(contact_id)["leads"].last
    if lead
      @lead_id = lead["id"]
    else
      new_lead = nutshell.new_lead({
        contacts: [{ id: contact_id }],
        products: [{ id: 1 }],
        note: ["Created via program application form."]
      })
      @lead_id = new_lead["id"]
    end
  end
end
