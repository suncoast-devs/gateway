# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

gem 'rails', '~> 6.1'

gem 'pg'
gem 'puma'
gem 'rack-cors'

gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bulma-rails'
gem 'commonmarker'
gem 'discard'
gem 'email_reply_trimmer'
gem 'full-name-splitter'
gem 'http', '~> 4.3'
gem 'jbuilder'
gem 'liquid'
gem 'mailchimp-api', require: 'mailchimp'
gem 'net-smtp'
gem 'olive_branch'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'pagy'
gem 'phony_rails'
gem 'postmark-rails'
gem 'premailer-rails'
gem 'sass-rails'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sentry-sidekiq'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'slim'
gem 'sprockets'
gem 'stripe'
gem 'truemail'

# https://github.com/rails/rails/pull/42366
# TODO: Remove when upgrading to Rails 7
gem 'net-imap', require: false
gem 'net-pop', require: false

group :development do
  gem 'awesome_print'
  gem 'byebug'
  gem 'listen'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'mutant-rspec'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'simplecov-lcov'
end

group :development, :test do
  gem 'prettier'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

source 'https://oss:xvgYUCDZBn8uoj9bBMpla8LfUax4zKfF@gem.mutant.dev' do
  gem 'mutant-license'
end
