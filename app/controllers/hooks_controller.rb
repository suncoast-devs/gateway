# frozen_string_literal: true

# TODO: Refactor into Service Objects
class HooksController < ApplicationController
  before_action :honey_pot
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
    CreateLead.call_later(
      params[:email],
      params[:givenName],
      params[:familyName],
      params[:source],
      params[:phone],
      params[:note],
    )
    head :ok
  end
end
