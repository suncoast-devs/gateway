# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.5.1"

gem "bootsnap", ">= 1.1.0", require: false
gem "jbuilder", "~> 2.5"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.1"
gem "rack-cors"

gem "commonmarker"
gem "full-name-splitter"
gem "graphql"
gem "graphiql-rails"
gem "http"
gem "mailchimp-api", require: "mailchimp"
gem "nutshell-crm-api"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "pagy"
gem "postmark-rails"
gem "premailer-rails"
gem "sentry-raven"
gem "slim"
gem "stripe"
gem "webpacker"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "awesome_print"
  gem "letter_opener"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "chromedriver-helper"
  gem "selenium-webdriver"
end
