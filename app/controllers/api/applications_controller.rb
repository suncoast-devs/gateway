module API
  class ApplicationsController < ApplicationController
    protect_from_forgery with: :null_session

    def submit
      execute(Enrollment::Application::Submit.new(**command_parameters))
      head :created
    end
  end
end
