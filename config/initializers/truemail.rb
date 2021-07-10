# frozen_string_literal: true
Truemail.configure do |config|
  config.verifier_email = 'hello@suncoast.io'
  config.verifier_domain = 'suncoast.io'
  config.default_validation_type = :regex
end
