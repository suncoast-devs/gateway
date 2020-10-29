class PersonMailer < ApplicationMailer
  layout "branded_email"

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

    # TODO: This is kind of a hack, is there a better way to do this? Make it part of the communication template model?
    if @communication_template.key === 'acceptance-letter'
      attachments["Program Catalog.pdf"] = File.read(Rails.root.join("app/assets/CATALOG.pdf"))
    end

    mail(to: "#{@person.full_name} <#{@person.email_address}>",
         subject: @communication_template.render_title(@person),
         track_opens: "true",) do |format|
      format.html { render layout: @communication_template.media, html: body  }
    end
  end
end
