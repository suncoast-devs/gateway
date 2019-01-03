# frozen_string_literal: true

# Provides program enrollments for review
class ProgramEnrollmentsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_program_enrollment, only: %i[show edit update]

  def index
    @query = params[:q]

    scope = ProgramEnrollment.joins(:person).order(created_at: :desc)

    if @query.present?
      scope = scope.where("people.full_name ILIKE ?", "%#{@query}%")
    end

    @pagy, @program_enrollments = pagy(scope)
  end

  def show
    @person = @program_enrollment.person
  end

  def edit; end

  def update
    @program_enrollment.update program_enrollment_params
    redirect_to @program_enrollment
  end

  private

  def find_program_enrollment
    @program_enrollment = ProgramEnrollment.find(params[:id])
  end

  def program_enrollment_params
    params.require(:program_enrollment).permit(:cohort_id, :stage, :status, :deposit_required, :deposit_paid, :enrollment_agreement_complete, :financial_clearance, :lost_reason)
  end
end
