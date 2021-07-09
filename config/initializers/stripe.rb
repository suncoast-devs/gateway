puts "WTF"
puts Rails.env
puts "==="

Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_key]