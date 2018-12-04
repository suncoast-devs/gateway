# frozen_string_literal: true

class HooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /lead
  # {
  #    givenName: "Werner",
  #    familyName: "Herzog",
  #    email: "werner.herzog@example.com",
  #    note: "Met a cool guy",
  #    source: "mailing-list"
  # }
  def lead
    CreateLeadJob.perform_later(params.email, params.givenName, params.familyName, params.source, params.note)
    head :ok
  end
end
