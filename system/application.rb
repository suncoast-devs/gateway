# frozen_string_literal: true

require 'bundler'
Bundler.require(:default, ENV.fetch('APP_ENV', :development))

require 'dry/system/container'
require 'dry/system/loader/autoloading'

#:nodoc:
class Application < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('APP_ENV', :development).to_sym }
  use :logging

  configure do |config|
    config.name = 'gateway'
    config.root = File.expand_path('..', __dir__)
    config.component_dirs.loader = Dry::System::Loader::Autoloading
    config.component_dirs.add 'lib'
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir Application.root.join('lib').realpath
loader.setup
