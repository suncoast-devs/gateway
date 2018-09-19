# frozen_string_literal: true

# Provides program application for review
class ProgramApplicationsController < ApplicationController
  before_action :authenticate!
  before_action :find_program_application, only: %i[show update]

  def index
    @program_applications = ProgramApplication.order(created_at: :desc)
  end

  def show; end

  def update
    @program_application.update program_application_params
    # TODO: Refactor this?
    if @program_application.saved_change_to_academic_signoff?
      UpdateSignoffJob.perform_later(@program_application.id, 'academic_signoff')
    end
    if @program_application.saved_change_to_administrative_signoff?
      UpdateSignoffJob.perform_later(@program_application.id, 'administrative_signoff')
    end
    redirect_to @program_application
  end

  private

  def find_program_application
    @program_application = ProgramApplication.find(params[:id])
  end

  def program_application_params
    params.require(:program_application).permit(:academic_signoff, :administrative_signoff)
  end
end
