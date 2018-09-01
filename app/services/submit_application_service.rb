class SubmitApplicationService

  def initialize(params)

  end

  def perform
    update_question_responses
    
  end

  private

  def program_application_url
    "https://gateway.suncoast.io/program_applications/#{@program_application.id}"
  end
end
