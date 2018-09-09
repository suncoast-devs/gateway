# frozen_string_literal: true

# Provides a service for completing a program application
class SubmitApplication
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
    @nutshell = Nutshell.client
  end

  def call
    update_crm_status
  end

  private

  def update_crm_status
    lead = @nutshell.get_lead(@program_application.crm_identifier)
    @nutshell.edit_lead(
      @program_application.crm_identifier,
      lead['rev'],
      note: "Application: #{program_application_url}",
      customFields: {
        'Application': 'Complete'
      }
    )
  end

  def program_application_url
    "https://gateway.suncoast.io/apps/#{@program_application.id}"
  end
end
