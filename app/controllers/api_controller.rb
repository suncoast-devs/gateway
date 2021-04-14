class APIController < ApplicationController
  protect_from_forgery with: :null_session
  rescue_from StandardError, with: :error_handler

  private

  def error_handler(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end
end
