class PersonMailer < ApplicationMailer
  default from: "Suncoast Developers Guild <hello@suncoast.io>"

  def acceptance_email
    @program_acceptance = params[:program_acceptance]
    @person = @program_acceptance.person
    attachments["Program Catalog.pdf"] = File.read(Rails.root.join("app/assets/CATALOG.pdf"))
    mail(to: "#{@person.full_name} <#{@person.email_address}>",
         bcc: ["bcc@nutshell.com"]
         subject: "Welcome to Suncoast Developers Guild!",
         track_opens: "true")
  end
end
