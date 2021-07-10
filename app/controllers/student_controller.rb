# frozen_string_literal: true
class StudentController < ApplicationController
  def status
    @program_enrollment = ProgramEnrollment.where(status_locator: params[:locator]).first
  end
end
