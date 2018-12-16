Raven.configure do |config|
  config.dsn = Rails.application.credentials.raven_dsn
end
