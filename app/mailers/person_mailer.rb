# frozen_string_literal: true
class PersonMailer < ApplicationMailer
  layout 'branded_email'

  after_action :record_communication

  # TODO: Move to communiation template.
  def part_time_registration_email
    @course_registration = params[:course_registration]
    @course = @course_registration.course
    @person = @course_registration.person
    @invoice = @course_registration.invoice

    mail(
      to: "#{@person.full_name} <#{@person.email_address}>",
      bcc: Rails.application.credentials.close_email,
      subject: "You're registered for #{@course.name} with Suncoast Developers Guild",
      track_opens: 'true',
    )
  end

  def communication_template_email
    @communication_template = params[:communication_template]
    @person = params[:person]

    body = @communication_template.render_body(@person)
    subject = @communication_template.render_title(@person)

    message_id = replied_message_id(@person, subject)

    headers({ 'References' => message_id, 'In-Reply-To' => message_id }) if message_id

    # FIXME: This is kind of a hack, is there better way to do this in communication template maybe?
    attachments['Program Catalog.pdf'] = Rails.root.join('app/assets/CATALOG.pdf').read if @communication_template
      .key === 'acceptance-letter'

    # if Truemail.valid? @person.email_address
    mail(
      to: "#{@person.full_name} <#{@person.email_address}>",
      bcc: Rails.application.credentials.close_email,
      subject:,
      track_opens: 'true',
    ) { |format| format.html { render layout: @communication_template.media, html: body } }
    # end
  end

  private

  def replied_message_id(person, subject)
    original_subject = subject.sub(/^(Re|Fwd): ?/i, '')
    communication = person.communications.email.where(subject: [original_subject, subject].uniq).recent.first
    if communication.present?
      previous_mail = Mail.new(communication.data['mail'])
      previous_mail.message_id
    end
  end

  def record_communication
    # re-encode without attachement before storing.
    email = mail.has_attachments? ? Mail.new(mail.encoded).without_attachments! : mail

    communication =
      Communication.outgoing.email.create(
        person: @person,
        subject: email.subject,
        body: sanitize_html(email.body),
        messaged_at: Time.zone.now,
        data: {
          had_attachments: mail.has_attachments?,
          template_key: @communication_template&.key,
          mail: email.encoded,
        },
      )
  end

  def sanitize_html(doc)
    ActionController::Base.helpers.strip_tags(doc.to_s.gsub(%r{<title>.*</title>}, '')).squish
  end
end
