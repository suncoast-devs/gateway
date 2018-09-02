# frozen_string_literal: true

# Provides User session management
class SessionsController < ApplicationController
  protect_from_forgery except: 'create'

  def create
    @user = User.from_auth_hash(request.env['omniauth.auth'])
    if @user
      session[:user_id] = @user.id
      redirect_to :program_applications
    else
      redirect_to :root
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
