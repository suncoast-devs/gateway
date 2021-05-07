# frozen_string_literal: true

APP_ENV = ENV.fetch('APP_ENV', :development).to_sym

require 'bundler'
Bundler.require(:default, APP_ENV)

require 'dry/system/container'
require 'dry/system/loader/autoloading'

#:nodoc:
class Application < Dry::System::Container
  use :env, inferrer: -> { APP_ENV }
  use :logging

  configure do |config|
    config.name = 'gateway'
    config.root = File.expand_path('..', __dir__)

    # config.component_dirs.loader = Dry::System::Loader::Autoloading
    config.component_dirs.add 'lib'
  end
end

Import = Application.injector
