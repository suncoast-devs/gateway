puts "WTF"
puts Rails.application.credentials[Rails.env.to_sym]
puts "==="

Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_key]