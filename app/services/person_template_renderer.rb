# frozen_string_literal: true
class PersonTemplateRenderer
  def initialize(person, template, options = {})
    @template = Liquid::Template.parse(template)
    @person = person
    @markdown = options[:markdown]
  end

  def render
    rendered_template = @template.render(params)
    
    if @markdown
      document = CommonMarker.render_doc(rendered_template, [:DEFAULT, :FOOTNOTES])
      document.to_html(:DEFAULT).html_safe
    else
      rendered_template
    end
  end

  private

  def params
    return @params if @params
    program_enrollment = @person.current_program_enrollment
    program_acceptance = @person.current_program_acceptance
    cohort = program_enrollment&.cohort
    @params = {
      'person' => @person,
      'cohort' => cohort,
      'enrollment' => program_enrollment,
      'acceptance' => program_acceptance
    }
  end
end