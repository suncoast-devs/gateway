# frozen_string_literal: true

# Provides a service for completing a program application
class SubmitApplication
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
    @nutshell = Nutshell.client
  end

  def call
    @program_application.update(application_status: :complete)
    update_crm_status
  end

  private

  def update_crm_status
    lead = @nutshell.get_lead(@program_application.person.crm_identifier)
    note = link_note
    @nutshell.edit_lead(
      @program_application.person.crm_identifier,
      lead['rev'],
      note: note,
      customFields: {
        'Application': 'Complete'
      }
    )
  end

  def program_application_url
    "https://gateway.suncoast.io/apps/#{@program_application.id}"
  end

  def link_note
    <<~NOTE
      Recieved an application for the #{@program_application.program.titleize} Program.

      #{program_application_url}
    NOTE
  end
end
