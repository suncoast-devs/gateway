# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.1'

gem 'dry-system'
gem 'pg'
gem 'rack'
gem 'rom'
gem 'rom-http'
gem 'rom-sql'

group :development, :test do
  gem 'prettier'
  gem 'pry'
  gem 'rake'
  gem 'rubocop'
  gem 'solargraph'
  gem 'standard'
end

group :test do
  gem 'guard-rspec', require: false
  gem 'mutant-rspec'
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'simplecov'
  gem 'simplecov-lcov'
end

source 'https://oss:xvgYUCDZBn8uoj9bBMpla8LfUax4zKfF@gem.mutant.dev' do
  gem 'mutant-license'
end
