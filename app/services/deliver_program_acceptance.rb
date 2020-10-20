class DeliverProgramAcceptance
  include Callable

  def initialize(program_acceptance_id)
    @program_acceptance = ProgramAcceptance.find program_acceptance_id
    @person = @program_acceptance.person
  end

  def call
    mail = PersonMailer.with(program_acceptance: @program_acceptance).acceptance_email.deliver_later
    @program_acceptance.update sent_at: Time.now, message_id: mail.message_id
  end
end
