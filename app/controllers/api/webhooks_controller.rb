# frozen_string_literal: true
module API
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    # POST /api/webhooks/:foo
    # {
    #   ...
    # }
    def index
      @webhook_event = WebhookEvent.create!(name: params[:name], payload: request.request_parameters)
      Webhooks::EventHandler.call_later(@webhook_event)
      head :ok
    end
  end
end
