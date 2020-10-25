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
end
