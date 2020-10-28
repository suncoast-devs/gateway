class CommunicationTemplate < ApplicationRecord
  belongs_to :user
  enum media: %i[simple_email branded_email sms]
  
  validates :name, presence: true
  validates :body, presence: true
  validates :key, presence: true, if: :is_system?

  def render_title(person)
    template = Liquid::Template.parse(title)
    template.render(params(person))
  end

  def render_body(person)
    template = Liquid::Template.parse(body)
    rendered_body = template.render(params(person))
    
    if sms?
      rendered_body
    else
      document = CommonMarker.render_doc(rendered_body, [:DEFAULT, :FOOTNOTES])
      document.to_html(:DEFAULT).html_safe
    end
  end

  # person, enrollment, cohort, acceptance
  def params(person)
    return @params if @params
    program_enrollment = person.current_program_enrollment
    program_acceptance = person.current_program_acceptance
    cohort = program_enrollment&.cohort
    @params = {
      "person" => person,
      "cohort" => cohort,
      "enrollment" => program_enrollment,
      "acceptance" => program_acceptance
    }
  end

  # TODO: Handle SMS.
  def send_to(person)
    mail = PersonMailer.with(communication_template: self, person: person).communication_email.deliver
    person.notes.create note_type: "email-event", message: "Sent #{name} email to #{person.given_name}.", data: { communication_template_id: self.id }
    person.attempt_contact!

    mail
  end

  class << self
    def by_key(key)
      where(key: key).first
    end
  end
end
