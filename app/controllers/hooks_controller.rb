# frozen_string_literal: true

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
    CreateLeadJob.perform_later(params[:email], params[:givenName], params[:familyName], params[:source], params[:phone], params[:note])
    head :ok
  end

  def stripe
    @invoice = Invoice.where(stripe_id: params[:data][:object][:id]).first
    if @invoice
      case params[:type]
      when 'invoice.payment_succeeded'
        @invoice.notes.create message: 'Payment suceeded.'
        @invoice.update is_paid: true
      when 'invoice.payment_failed'
        @invoice.notes.create message: 'Payment failed.'
      end
    end
    head :ok
  end
end
