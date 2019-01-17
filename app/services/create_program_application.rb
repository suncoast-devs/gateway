class CreateProgramApplication
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
  end

  def call
    ActiveCampaign.event("new_application", @program_application.person.email_address, @program_application.program)
  end
end
