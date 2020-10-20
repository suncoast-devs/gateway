# frozen_string_literal: true

# :nodoc:
class ApplicationController < ActionController::Base
  before_action :set_raven_context

  def authenticate!
    redirect_to :sign_in unless signed_in?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue StandardError
    session[:user_id] = nil
  end

  helper_method :current_user

  def signed_in?
    !current_user.nil?
  end

  helper_method :signed_in?

  def honey_pot
    head :ok if params["contactMeOnlyByCarrierPigeon"]
  end

  def set_raven_context
    Raven.user_context(email: current_user&.email)
  end

  def publish_event(name, payload = {})
    payload[:current_user] = current_user if signed_in?
    ActiveSupport::Notifications.instrument "#{name}.gateway", payload
  end
end
