# frozen_string_literal: true

# Provides Program Acceptances
class ProgramAcceptancesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_program_enrollment
  before_action :find_program_acceptance, only: %i[show edit update deliver]

  def show
  end

  def new
    @program_acceptance = @program_enrollment.program_acceptances.new
  end

  def create
    @program_acceptance = @program_enrollment.program_acceptances.new(program_acceptance_params)
    if @program_acceptance.save
      CreateProgramAcceptance.call_later @program_acceptance
      redirect_to @program_enrollment.person
    else
      render :new
    end
  end

  def update
    @program_acceptance.update(program_acceptance_params)
    redirect_to @program_enrollment.person
  end

  private

  def find_program_enrollment
    @program_enrollment = ProgramEnrollment.find(params[:program_enrollment_id])
  end

  def find_program_acceptance
    @program_acceptance = @program_enrollment.program_acceptances.find(params[:id])
    @person = @program_acceptance.person
  end

  def program_acceptance_params
    params.require(:program_acceptance).permit(:cohort_id, :tuition_reduction, :notification_body, :is_rescinded, 
:is_update, :note, :payment_url)
  end
end
