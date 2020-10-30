class PersonMailer < ApplicationMailer
  layout "branded_email"

  after_action :record_communication

  # TODO: Move to communiation template?
  def part_time_registration_email
    @course_registration = params[:course_registration]
    @course = @course_registration.course
    @person = @course_registration.person
    @invoice = @course_registration.invoice

    mail(to: "#{@person.full_name} <#{@person.email_address}>",
         subject: "You're registered for #{@course.name} with Suncoast Developers Guild",
         track_opens: "true")
  end

  def communication_email
    @communication_template = params[:communication_template]
    @person = params[:person]

    body = @communication_template.render_body(@person)

    # FIXME: This is kind of a hack, is there better way to do this in communication template maybe?
    if @communication_template.key === "acceptance-letter"
      attachments["Program Catalog.pdf"] = File.read(Rails.root.join("app/assets/CATALOG.pdf"))
    end

    mail(to: "#{@person.full_name} <#{@person.email_address}>",
         subject: @communication_template.render_title(@person),
         track_opens: "true") do |format|
      format.html { render layout: @communication_template.media, html: body }
    end
  end

  private

  def record_communication
    # re-encode without attachement before storing.
    email = mail.has_attachments? ? Mail.new(mail.encoded).without_attachments! : mail

    Communication.create(
      person: @person,
      media: "email",
      subject: email.subject,
      body: sanitize_html(email.html_part.body),
      messaged_at: Time.now,
      data: {
        had_attachments: mail.has_attachments?,
        template_key: @communication_template&.key,
        mail: email.encoded,
      },
    )
  end

  def sanitize_html(doc)
    ActionController::Base.helpers.strip_tags(doc.to_s.gsub(/<title>.*<\/title>/, "")).squish
  end
end
