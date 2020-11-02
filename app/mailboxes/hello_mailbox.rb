class HelloMailbox < ApplicationMailbox
  def process
    CreateInboundEmailCommunication.call_later(inbound_email)
  end
end
