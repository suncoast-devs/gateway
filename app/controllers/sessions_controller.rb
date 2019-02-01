# frozen_string_literal: true

# Provides User session management
class SessionsController < ApplicationController
  protect_from_forgery except: "create"

  def create
    @user = User.from_auth_hash(request.env["omniauth.auth"])
    session[:user_id] = @user.id if @user
    redirect_to :root
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
