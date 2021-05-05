# frozen_string_literal: true

require 'rom/sql/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

require_relative 'system/application'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: [:spec]
