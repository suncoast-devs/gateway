class HelloMailbox < ApplicationMailbox
  def process
    sender.communications.incoming.email.create!(
      subject: mail.subject,
      body: parsed_body,
      messaged_at: Time.now,
      data: {
        mail: mail.encoded,
      },
    )
  end

  private

  def parsed_body
    text = nil
    html = nil

    if mail.multipart?
      text = mail.text_part&.body&.decoded
      html = mail.html_part&.body&.decoded
    else
      text ||= mail&.body&.decoded if mail.content_type !~ /text\/html/
    end

    if text.blank? && html.present?
      text = ActionController::Base.helpers.strip_tags(html)
    end

    encoding = text.encoding
    text = EmailReplyTrimmer.trim(text)
    text.force_encoding(encoding).encode("UTF-8")
  end

  def from_email
    mail.from_address.address
  end

  def from_name
    mail.from_address.name
  end

  def sender
    @sender ||= Person.where("lower(email_address) = ?", from_email.downcase).first_or_create do |person|
      given_name, family_name = FullNameSplitter.split(from_name)
      person.email_address = from_email
      person.given_name = given_name
      person.family_name = family_name
      person.full_name = from_name
      person.source = "Hello Mailbox"
    end
  end
end
