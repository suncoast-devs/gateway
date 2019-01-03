# frozen_string_literal: true

# Provides Program Acceptances
class ProgramAcceptancesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_person
  before_action :find_program_acceptance, only: [:show, :edit, :update, :deliver]

  def new
    @program_acceptance = @person.program_acceptances.new
  end

  def create
    @program_acceptance = @person.program_acceptances.new(program_acceptance_params)
    if @program_acceptance.save
      # No job, this needs to be done synchronously before redirect.
      CreateProgramAcceptance.call @program_acceptance.id
      redirect_to [:edit, @person, @program_acceptance]
    else
      render :new
    end
  end

  def update
    if @program_acceptance.update(program_acceptance_params)
      redirect_to [@person, @program_acceptance]
    else
      render [:edit, @person, @program_acceptance]
    end
  end

  def show
  end

  def deliver
    DeliverProgramAcceptanceJob.perform_later(@program_acceptance.id)
    redirect_to @person, notice: "Delivering program acceptance email."
  end

  private

  def find_person
    @person = Person.find(params[:person_id])
  end

  def find_program_acceptance
    @program_acceptance = @person.program_acceptances.find(params[:id])
  end

  def program_acceptance_params
    params.require(:program_acceptance).permit(:cohort_id, :program_application_id, :program_enrollment_id, :tuition_reduction, :notification_body)
  end
end
