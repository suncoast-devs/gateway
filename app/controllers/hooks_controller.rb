# frozen_string_literal: true

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /lead
  # {
  #    givenName: "Werner",
  #    familyName: "Herzog",
  #    email: "werner.herzog@example.com",
  #    source: "mailing-list"
  # }
  def lead
    CreateLeadJob.perform_later(params.email, params.givenName, params.familyName, params.source)
    head :ok
  end
end
