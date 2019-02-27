# frozen_string_literal: true

# Provides program enrollments for review
class CourseRegistrationsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!

  def index
    scope = CourseRegistration.joins(:person, :course).order(created_at: :desc)
    @pagy, @course_registrations = pagy(scope)
  end
end
