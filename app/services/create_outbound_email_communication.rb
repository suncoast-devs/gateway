# frozen_string_literal: true

# TODO: From Current user with signature.
class CreateOutboundEmailCommunication
  include Callable

  def initialize(person, title, body)
    @person = person
    @communication_template = CommunicationTemplate.simple_email.new({ title:, body: })
  end

  def call
    @communication_template.send_to(@person)
  end
end
