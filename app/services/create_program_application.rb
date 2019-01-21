class CreateProgramApplication
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
  end

  def call
    if @program_application.program == "web-development"
      ActiveCampaign.event("new_application", @program_application.person.email_address)
      ActiveCampaign.post("fieldValues", {
        fieldValue: {
          contact: @program_application.person.ac_contact_identifier,
          field: ActiveCampaign::FIELD_IDS["continue_application_url"],
          value: @program_application.send("ac_continue_application_url_value"),
        },
      })
    end
  end
end
