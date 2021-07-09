# frozen_string_literal: true

# Provides program enrollments for review
class ProgramEnrollmentsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_program_enrollment, only: %i[show edit update]

  def index
    @query = params[:query]
    @status = params[:status]
    @stage = params[:stage]
    @cohort = params[:cohort]

    scope = ProgramEnrollment.joins(:person).order(created_at: :desc)
    scope = scope.where("people.full_name ILIKE ?", "%#{@query}%") if @query.present?
    scope = scope.where(status: @status.split(",")) if @status.present?
    scope = scope.where(stage: @stage.split(",")) if @stage.present?

    unless @cohort.nil?
      if @cohort.blank?
        scope = scope.where(cohort_id: nil)
      else
        scope = scope.joins(:cohort).merge(Cohort.where(name: @cohort.split(",")))
      end
    end

    @pagy, @program_enrollments = pagy(scope)
  end

  def show
    redirect_to @program_enrollment.person
  end

  def edit; end

  def update
    if program_enrollment_params[:person_id] != @program_enrollment.person_id
      @program_enrollment.program_applications.update_all(person_id: program_enrollment_params[:person_id])
    end
    @program_enrollment.update program_enrollment_params 

    SendLeadToClose.call_later(@program_enrollment.person)
    redirect_to @program_enrollment.person
  end

  private

  def find_program_enrollment
    @program_enrollment = ProgramEnrollment.find(params[:id])
  end

  def program_enrollment_params
    params.require(:program_enrollment).permit(:person_id, :cohort_id, :stage, :status, :deposit_required, :deposit_paid, :enrollment_agreement_complete, :financial_clearance, :lost_reason, :academic_signoff, :administrative_signoff)
  end
end
