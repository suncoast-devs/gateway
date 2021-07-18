# frozen_string_literal: true

class InterviewReminder
  include Callable

  def initialize(person)
    @person = person
    @program_enrollment = @person.current_program_enrollment
  end

  def call
    CommunicationTemplate.by_key('schedule-interview')&.send_to(@person) if @program_enrollment.applied?
  end
end
