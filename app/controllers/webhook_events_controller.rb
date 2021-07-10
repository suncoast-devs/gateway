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

  def replay
    @webhook_event = WebhookEvent.find(params[:id])
    Webhooks::EventHandler.call_later(@webhook_event)
    redirect_to @webhook_event, notice: 'Replayed Webhook Event'
  end
end
