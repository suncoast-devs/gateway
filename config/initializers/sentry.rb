Sentry.init do |config|
  config.dsn = Rails.application.credentials.raven_dsn
  config.send_default_pii = true
  config.environments = %w[staging production]
  config.processors -= [Raven::Processor::PostData]
end
