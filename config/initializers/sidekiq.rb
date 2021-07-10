# frozen_string_literal: true
Sidekiq.configure_client { |config| config.redis = { size: 1 } }
