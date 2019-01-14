# Preview all emails at http://localhost:3000/rails/mailers/person_mailer
class PersonMailerPreview < ActionMailer::Preview
  def acceptance_email
    PersonMailer.with(program_acceptance: ProgramAcceptance.active.first).acceptance_email
  end
end
