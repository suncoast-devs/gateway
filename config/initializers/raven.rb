Raven.configure do |config|
  config.dsn = Rails.application.credentials.raven_dsn
  config.environments = %w(staging production)
  config.processors -= [Raven::Processor::PostData]
end
