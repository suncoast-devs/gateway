class PersonMailerPreview < ActionMailer::Preview

  def communication_email
    PersonMailer.with(params).communication_email
  end
end