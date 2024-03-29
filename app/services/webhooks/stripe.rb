# frozen_string_literal: true
module Webhooks
  class Stripe
    include Callable

    attr_reader :params

    def initialize(params)
      @params = params.with_indifferent_access
    end

    def call
      @invoice = Invoice.where(stripe_id: params[:data][:object][:id]).first
      if @invoice
        case params[:type]
        when 'invoice.payment_succeeded'
          @invoice.notes.create note_type: 'invoice-event', message: 'Payment suceeded.', data: @params
          InvoicePaymentHandler.call_later(@invoice)
        when 'invoice.payment_failed'
          @invoice.notes.create note_type: 'invoice-event', message: 'Payment failed.', data: @params
        end
      end
    end
  end
end
