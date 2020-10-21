class EventFormatter
  include Rails.application.routes.url_helpers
  
  attr :title, :message, :link_url, :payload, :event

  def initialize(event)
    @event = event
    @payload = event.payload
    @title, @message, @link_url, @is_notifiable = send @event.name.match(/(?<name>\w+)\.gateway/)[:name]
  end

  def is_notifiable?
    @is_notifiable
  end

  private

  def create_note
    note = payload
    notable = note.notable
    
    case notable
    when Person then
      return "#{note.user.first_name} made a comment on #{notable.full_name}.", note.message, person_url(notable), true
    when ProgramApplication
      return "#{note.user.first_name} left interview notes on #{notable.full_name}'s application.", note.message, program_application_url(notable), true
    when Invoice then
      return "#{notable.persons.full_name}'s invoice was updated.", note.message, invoice_url(notable), true
    else
      unhandled_event_format
    end
  end

  def complete_application
    program_application = payload
    return "An application has been submitted by #{program_application.person.full_name}.", "", program_application_url(program_application), true
  end

  def unhandled_event_format
    return "An unhandled event notification has occured.", "This event does not have a formatter implemented. See the `EventFormatter` class.", root_url, false
  end

  class << self
    def default_url_options
      Rails.application.routes.default_url_options
    end
  end
end
