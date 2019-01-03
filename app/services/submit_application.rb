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
    create_program_enrollment
  end

  private

  def create_program_enrollment
    if @program_application.program == "web-development"
      if @program_application.person.program_enrollments.count > 0
        # TODO: Eventually this will need to be refactored, if we offer more than one type of program.
        @program_application.update(program_enrollment: @program_application.person.program_enrollments.first)
      else
        ProgramEnrollment.create({
          person: @program_application.person,
          program: web_development,
          program_applications: [@program_application],
        })
      end
    end
  end

  def update_crm_status
    lead = @nutshell.get_lead(@program_application.person.crm_identifier)
    options = {note: link_note}
    if @program_application.program == "web-development"
      options[:customFields] = {'Application': "Complete"}
    end

    @nutshell.edit_lead(
      @program_application.person.crm_identifier,
      lead["rev"],
      options
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
