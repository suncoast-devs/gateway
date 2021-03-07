# frozen_string_literal: true

class HomeController < ApplicationController
  include Pagy::Backend

  def index
    if signed_in?
      @pagy, @events = pagy(Event.order(created_at: :desc))
      @calendar_events = CalendarEvent.upcoming
    end
  end
end
