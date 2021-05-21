# frozen_string_literal: true

Application.boot(:sidekiq) do |_app|
  init do   
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV['REDIS_URL'] }
    end
  end
end
