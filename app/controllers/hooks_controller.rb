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

  def activecampaign
    case params[:type]
    when "deal_update"
      enrollment = ProgramEnrollment.where(ac_deal_identifier: params[:deal][:id]).first
      if enrollment
        enrollment.update(status: params[:deal][:status].to_i, stage: params[:deal][:stageid].to_i)
      end
    when "update"
      person = Person.where(ac_contact_identifier: params[:contact][:id]).first
      if person
        person.full_name = [params[:contact][:first_name], params[:contact][:last_name]].join(" ")
        person.email_address = params[:contact][:email] if params[:contact][:email].present?
        person.phone_number = params[:contact][:phone] if params[:contact][:phone].present?
        person.save
      end
    when "subscribe"
      @person = Person.where("lower(email_address) = ?", params[:contact][:email].downcase).first_or_initialize do |person|
        person.full_name = [params[:contact][:first_name], params[:contact][:last_name]].join(" ")
        person.email_address = params[:contact][:email] if params[:contact][:email].present?
        person.phone_number = params[:contact][:phone] if params[:contact][:phone].present?
        person.source = "active-campaign"
        person.ac_contact_identifier = params[:contact][:id]
        person.save
      end
    end
  end

  def slack
    if params[:type] == "url_verification"
      render(json: {challenge: params[:challenge]})
      return
    end

    case params[:event][:type]
    when "team_join"
      profile = params[:event][:user][:profile]
      mailchimp = Mailchimp::API.new(Rails.application.credentials.mailchimp_api_key)
      given_name, family_name = FullNameSplitter.split(profile[:real_name])
      mailchimp.lists.subscribe("3d4e0699f1",
                                {email: profile[:email]},
                                {FNAME: given_name, LNAME: family_name},
                                "html")
    end

    head :ok
  end
end
