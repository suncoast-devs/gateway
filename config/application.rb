# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "action_mailbox/engine"

Bundler.require(*Rails.groups)

module Gateway
  # :nodoc:
  class Application < Rails::Application
    RAILS_ROUTES = ->(env) { env["PATH_INFO"].match(/^\/rails/) }

    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.preview_path = "#{Rails.root}/app/mailers/previews"
    config.time_zone = "Eastern Time (US & Canada)"
    config.middleware.use OliveBranch::Middleware,
      inflection: "camel",
      exclude_params: RAILS_ROUTES,
      exclude_response: RAILS_ROUTES
    config.action_mailbox.ingress = :postmark
  end
end
