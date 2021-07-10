# frozen_string_literal: true

class InterviewReminder
  include Callable

  def initialize(person)
    @person = person
    @program_enrollment = @person.current_program_enrollment
  end

  def call
    if @program_enrollment.active? && @program_enrollment.applied?
      CommunicationTemplate.by_key('schedule-interview')&.send_to(@person)
    end
  end
end
