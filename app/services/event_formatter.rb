# frozen_string_literal: true
class EventFormatter
  include Rails.application.routes.url_helpers

  attr :title, :message, :link_url, :payload, :event

  def initialize(event)
    @event = event
    @payload = event.payload
    @name = @event.name.match(/(?<name>\w+)\.gateway/)[:name]
    @title, @message, @link_url, @is_notifiable = respond_to?(@name, true) ? send(@name) : unhandled_event_format
  end

  def is_notifiable?
    @is_notifiable
  end

  private

  def create_note
    note = payload
    notable = note.notable

    case notable
    when Person
      ["#{note.user.first_name} made a comment on #{notable.full_name}.", note.message, person_url(notable), true]
    when ProgramApplication
      [
        "#{note.user.first_name} left interview notes on #{notable.full_name}'s application.",
        note.message,
        program_application_url(notable),
        true,
      ]
    when Invoice
      ["#{notable.persons.full_name}'s invoice was updated.", note.message, invoice_url(notable), true]
    else
      unhandled_event_format
    end
  end

  def complete_application
    program_application = payload
    [
      "An application has been submitted by #{program_application.person.full_name}.",
      '',
      program_application_url(program_application),
      true,
    ]
  end

  def course_registration
    course_registration = payload
    [
      'New weekend course registration.',
      "#{course_registration.person.full_name} has registered for #{course_registration.course.display_name}.",
      person_url(course_registration.person),
      true,
    ]
  end

  def interview_scheduled
    calendar_event = payload
    person = calendar_event.person
    if person
      ["#{person.full_name} has scheduled an interview.", calendar_event.starts_at, person_url(person), true]
    else
      ['An interview has been scheduled.', calendar_event.starts_at, root_url, true]
    end
  end

  def interview_canceled
    calendar_event = payload
    person = calendar_event.person
    if person
      ["#{person.full_name} has canceled an interview.", calendar_event.starts_at, person_url(person), true]
    else
      ['An interview has been canceled.', calendar_event.starts_at, root_url, true]
    end
  end

  def communication_received
    communication = payload
    person = communication.person

    # TODO: Actual routes for client paths?
    [
      "New message from #{person.full_name}.",
      communication.body.truncate(200),
      root_url + "app/messages/#{person.id}",
      true,
    ]
  end

  def unhandled_event_format
    [
      'An unhandled event notification has occured.',
      "This `#{@name}` event does not have a formatter implemented. See the `EventFormatter` class.",
      root_url,
      false,
    ]
  end

  class << self
    def default_url_options
      Rails.application.routes.default_url_options
    end
  end
end
