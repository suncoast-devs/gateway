module API
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    # POST /api/webhooks/:foo
    # {
    #   ...
    # }
    def index
      "Webhooks::#{params[:webhook].camelize}".constantize.call_later(request.request_parameters)
      head :ok
    end
  end
end
