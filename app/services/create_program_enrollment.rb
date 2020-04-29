# frozen_string_literal: true

# Provides a service for completing a program application
class CreateProgramEnrollment
  include Callable

  def initialize(program_application_id)
    @program_application = ProgramApplication.find(program_application_id)
  end

  def call
    @program_application.update(application_status: :complete)
    if @program_application.program == "web-development"
      if @program_application.person.program_enrollments.count > 0
        # TODO: Eventually this will need to be refactored, if we offer more than one type of program.
        @program_application.update(program_enrollment: @program_application.person.program_enrollments.first)
      else
        program_start = @program_application.question_responses["When are you hoping to start the program?"]
        cohort_name = program_start.match(/Cohort ([IVX]+)/).try(:[], 1) || "Future"
        enrollment = ProgramEnrollment.create!({
          cohort: Cohort.where(name: cohort_name).first,
          person: @program_application.person,
          program: "web-development",
          program_applications: [@program_application],
        })
      end
    end
  end
end
