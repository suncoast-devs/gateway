class PersonMailerPreview < ActionMailer::Preview

  def communication_email
    person = Person.find(params[:person_id])
    template = CommunicationTemplate.find(params[:communication_template_id])
    PersonMailer.with({ person: person, communication_template: template }).communication_email
  end
end
