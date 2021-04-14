module API
  class ApplicationsController < APIController
    def submit
      execute(Enrollment::Application::Submit.new(**command_parameters))
      head :created
    end
  end
end
