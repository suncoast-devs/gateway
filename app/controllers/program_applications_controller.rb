# frozen_string_literal: true

# Provides program application for review
class ProgramApplicationsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!
  before_action :find_program_application, only: %i[show edit update]

  def index
    @query = params[:q]

    scope = ProgramApplication.joins(:person).order(created_at: :desc)

    if @query.present?
      scope = scope.where("people.full_name ILIKE ?", "%#{@query}%")
    else
      # Only use this scope if search query isn't present (i.e., allow searching hidden applications)
      scope = params[:hidden] ? scope.hidden : scope.visible
    end

    @pagy, @program_applications = pagy(scope)
  end

  def show; end

  def edit; end

  def update
    @program_application.update program_application_params
    redirect_to @program_application
  end

  private

  def find_program_application
    @program_application = ProgramApplication.find(params[:id])
  end

  def program_application_params
    params.require(:program_application).permit(:full_name, :email_address, :phone_number, :application_status, :interview_status, :acceptance_status, :academic_signoff, :administrative_signoff, :is_hidden)
  end
end
