Sentry.init do |config|
  config.dsn = Rails.application.credentials.raven_dsn
  config.send_default_pii = true
  config.enabled_environments = %w[production]
end
