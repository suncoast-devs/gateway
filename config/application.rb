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
require "rails/test_unit/railtie"
require "sprockets/railtie" # if Rails.env.development?

Bundler.require(*Rails.groups)

module Gateway
  # :nodoc:
  class Application < Rails::Application
    config.load_defaults 5.2
  end
end
