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
    CreateLead.call_later(params[:email], params[:givenName], params[:familyName], params[:source], params[:phone], params[:note])
    head :ok
  end

  def stripe
    @invoice = Invoice.where(stripe_id: params[:data][:object][:id]).first
    if @invoice
      case params[:type]
      when "invoice.payment_succeeded"
        @invoice.notes.create note_type: "invoice-event", message: "Payment suceeded.", data: request.request_parameters
        @invoice.update is_paid: true
      when "invoice.payment_failed"
        @invoice.notes.create note_type: "invoice-event", message: "Payment failed.", data: request.request_parameters
      end
    end
    head :ok
  end

  # TODO: Possible refactor for generic email message model is required?
  def postmark
    @program_acceptance = ProgramAcceptance.where(message_id: params[:MessageID]).first
    if @program_acceptance
      note = case params[:RecordType]
             when "Delivery" then "Acceptance email delivered to #{params[:Recipient]}."
             when "Bounce" then "Acceptance email not delivered to #{params[:Recipient]}.\n\n> #{params[:Description]}"
             when "SpamComplaint" then "Acceptance email to #{params[:Recipient]} flagged as spam."
             when "Open" then "Acceptance email opened."
             when "Click" then "Link clicked in acceptance email."
             end
      @program_acceptance.person.notes.create note_type: "email-event", message: note, data: request.request_parameters
    end
    head :ok
  end

  def slack
    if params[:type] == "url_verification"
      render(json: {challenge: params[:challenge]})
      return
    end

    head :ok
  end
end
