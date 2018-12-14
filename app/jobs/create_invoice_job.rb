# frozen_string_literal: true

# Async worker for creating an invoice in Stripe.
class CreateInvoiceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    CreateInvoice.call(*args) if Rails.env.production?
  end
end
