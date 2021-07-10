# frozen_string_literal: true
Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end
