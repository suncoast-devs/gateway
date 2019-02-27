class PersonMailer < ApplicationMailer
  default from: "Suncoast Developers Guild <hello@suncoast.io>"

  def acceptance_email
    @program_acceptance = params[:program_acceptance]
    @person = @program_acceptance.person
    attachments["Program Catalog.pdf"] = File.read(Rails.root.join("app/assets/CATALOG.pdf"))
    mail(to: "#{@person.full_name} <#{@person.email_address}>",
         subject: "Welcome to Suncoast Developers Guild!",
         track_opens: "true")
  end

  def part_time_registration_email
    @course_registration = params[:course_registration]
    @course = @course_registration.course
    @person = @course_registration.person
    @invoice = @course_registration.invoice

    mail(to: "#{@person.full_name} <#{@person.email_address}>",
         subject: "You're registered for #{@course.name} with Suncoast Developers Guild",
         track_opens: "true")
  end
end
