# frozen_string_literal: true

# Provides Program Acceptances
class ProgramAcceptancesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_program_enrollment
  before_action :find_program_acceptance, only: [:show, :edit, :update, :deliver]

  def new
    @program_acceptance = @program_enrollment.program_acceptances.new
  end

  def create
    @program_acceptance = @program_enrollment.program_acceptances.new(program_acceptance_params)
    if @program_acceptance.save
      # NOTE: This needs to be done synchronously before redirect, so no call_later.
      CreateProgramAcceptance.call @program_acceptance.id
      redirect_to [:edit, @program_enrollment, @program_acceptance]
    else
      render :new
    end
  end

  def update
    if @program_acceptance.update(program_acceptance_params)
      redirect_to [@program_enrollment, @program_acceptance]
    else
      render [:edit, @program_enrollment, @program_acceptance]
    end
  end

  def show
  end

  def deliver
    DeliverProgramAcceptance.call_later(@program_acceptance.id)
    redirect_to @program_enrollment, notice: "Delivering program acceptance email."
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
    params.require(:program_acceptance).permit(:cohort_id, :tuition_reduction, :notification_body)
  end
end
