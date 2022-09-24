# frozen_string_literal: true
Sentry.init do |config|
  config.dsn = Rails.application.credentials.raven_dsn
  config.send_default_pii = true
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
  config.release = ENV.fetch('HEROKU_SLUG_COMMIT', 'development')
end
