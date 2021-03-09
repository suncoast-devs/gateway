# frozen_string_literal: true

class WebhookEventsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate!

  def index
    scope = WebhookEvent.order(created_at: :desc)
    @pagy, @webhook_events = pagy(scope)
  end

  def show
    @webhook_event = WebhookEvent.find(params[:id])
  end
end
