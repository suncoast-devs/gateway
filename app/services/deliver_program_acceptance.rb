class DeliverProgramAcceptance
  include Callable

  def initialize(program_acceptance_id)
    @program_acceptance = ProgramAcceptance.find program_acceptance_id
    @person = @program_acceptance.person
  end

  def call
    mail = PersonMailer.with(program_acceptance: @program_acceptance).acceptance_email.deliver_now
    @program_acceptance.update sent_at: Time.now, message_id: mail.message_id
    @program_acceptance.program_application.acceptance_sent!
  end
end
