# frozen_string_literal: true

class HomeController < ApplicationController
  include Pagy::Backend
  
  def index
    if signed_in?
      scope = Event.order(created_at: :desc)
      @pagy, @events = pagy(scope)
    end
  end
end
