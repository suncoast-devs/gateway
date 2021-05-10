# frozen_string_literal: true

require 'rom/sql/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new
RuboCop::RakeTask.new

namespace :db do
  task :setup do
    require_relative 'system/application'
    Application.start(:db)
  end
end

task default: [:spec]
