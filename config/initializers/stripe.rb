# frozen_string_literal: true
Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_key]
