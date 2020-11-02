# frozen_string_literal: true

# TODO: From Current user with signature.
class CreateEmailCommunication
  include Callable

  def initialize(person, subject, body)
    @person = person
    @communication_template = CommunicationTemplate.simple_email.new({
      title: subject,
      body: body,
    })
  end

  def call
    @communication_template.send_to(@person)
  end
end
