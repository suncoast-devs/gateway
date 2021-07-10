# frozen_string_literal: true

# Provides a service for completing a program application
class CreateProgramEnrollment
  include Callable

  def initialize(program_application)
    @program_application = program_application
  end

  def call
    @program_application.update(application_status: :complete)
    if @program_application.program == 'web-development'
      if @program_application.person.program_enrollments.count.positive?
        @program_application.update(program_enrollment: @program_application.person.current_program_enrollment)
      else
        enrollment =
          ProgramEnrollment.create!(
            {
              cohort: Cohort.where(name: program_start).first,
              person: @program_application.person,
              program: 'web-development',
              program_applications: [@program_application],
            },
          )

        CommunicationTemplate.by_key('application-received')&.send_to @program_application.person
        InterviewReminder.call_in 2.days, @program_application.person
        SendLeadToClose.call_later(@program_application.person)
      end
    end
  end

  private

  def program_start
    keys = @program_application.question_responses.keys.grep /start the program/
    answer = @program_application.question_responses[keys.first]
    answer.match(/(\d+)/).try(:[], 1) || 'Future'
  rescue StandardError
    'Future'
  end
end
