# frozen_string_literal: true

class CreateInboundEmailCommunication
  include Callable

  def initialize(inbound_email)
    @inbound_email = inbound_email
    @mail = inbound_email.mail
  end

  def call
    communication = sender.communications.email.incoming.create!(
      subject: @mail.subject,
      body: parsed_body,
      messaged_at: Time.now,
      data: {
        mail: @mail.encoded,
      },
    )

    sender.update last_communication: communication
    ActiveSupport::Notifications.instrument "communication_received.gateway", [communication]
  end

  private

  def parsed_body
    text = nil
    html = nil

    if @mail.multipart?
      text = @mail.text_part&.body&.decoded
      html = @mail.html_part&.body&.decoded
    else
      if @mail.content_type !~ /text\/html/
        html = @mail&.body&.decoded
      else
        text = @mail&.body&.decoded
      end
    end

    if text.blank? && html.present?
      text = ActionController::Base.helpers.strip_tags(html)
    end

    text = text.encode(Encoding.find("UTF-8"), { invalid: :replace, undef: :replace, replace: "" })

    EmailReplyTrimmer.trim(text)
  end

  def from_email
    @mail.from_address.address
  end

  def from_name
    @mail.from_address.name
  end

  def sender
    @sender ||= Person.where("lower(email_address) = ?", from_email.downcase).first_or_create do |person|
      given_name, family_name = FullNameSplitter.split(from_name)
      person.email_address = from_email
      person.given_name = given_name
      person.family_name = family_name
      person.full_name = from_name
      person.source = "Inbound Email"
    end
  end
end
