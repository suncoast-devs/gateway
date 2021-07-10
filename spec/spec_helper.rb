# frozen_string_literal: true
require 'simplecov'
require 'simplecov-lcov'
SimpleCov.start { add_filter '/spec/' }
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter

RSpec.configure do |config|
  # TODO: Remove Rspec 4 defaults after updating to Rspec 4

  # = begin
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # = end

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.filter_run_when_matching :focus
  config.order = :random
  config.profile_examples = 10

  config.default_formatter = 'doc' if config.files_to_run.one?

  Kernel.srand config.seed
end
