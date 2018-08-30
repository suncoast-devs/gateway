class ProgramApplicationsController < ApplicationController
  before_action :authenticate!

  def index
    @program_applications = ProgramApplication.all
  end

  def show
    @program_application = ProgramApplication.find(params[:id])
  end
end
