# frozen_string_literal: true

# Provides a service for completing a program application
class SubmitApplicationService
  def initialize(params)
    @params = params.slice(:id, :qa)
    @nutshell = Nutshell.client
  end

  def perform
    update_question_responses
    update_crm_status
    @program_application
  end

  private

  def update_question_responses
    @program_application = ProgramApplication.find @params[:id]
    @program_application.update! question_responses: @params[:qa]
  end

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
