# frozen_string_literal: true
class PersonMailerPreview < ActionMailer::Preview
  def communication_template_email
    person = Person.find(params[:person_id])
    template = CommunicationTemplate.find(params[:communication_template_id])
    PersonMailer.with({ person:, communication_template: template }).communication_template_email
  end
end
