class EventFormatter
  include Rails.application.routes.url_helpers
  
  attr :title, :message, :link_url

  def initialize(event)
    @event = event
    @payload = event.payload.with_indifferent_access
    @title, @message, @link_url = send @event.name.match(/(?<name>\w+)\.gateway/)[:name]
  end

  private

  def create_note
    note = Note.find(@payload[:id])
    notable = note.notable
    
    case notable
    when Person then
      return "#{note.user.first_name} made a comment on #{notable.full_name}.", note.message, person_url(notable)
    when ProgramApplication
      return "#{note.user.first_name} left interview notes on #{notable.full_name}'s application.", note.message, program_application_url(notable)
    when Invoice then
      return "#{notable.persons.full_name}'s invoice was updated.", note.message, invoice_url(notable)
    else
      unhandled_event_format
    end
  end

  def complete_application
    program_application = ProgramApplication.find(@payload[:id])
    return "An application has been submitted by #{program_application.person.full_name}.", "", program_application_url(program_application)
  end

  def unhandled_event_format
    return "An unhandled event notification has occured.", "This event does not have a formatter implemented. See the `EventFormatter` class.", root_url
  end

  class << self
    def default_url_options
      Rails.application.routes.default_url_options
    end
  end
end
