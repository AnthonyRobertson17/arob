# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1"

# [https://github.com/haml/haml]
gem "haml", "~> 6.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "~> 3.5"

# Use postgresql as the database for Active Record [https://github.com/ged/ruby-pg]
gem "pg", "~> 1.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4"

# https://github.com/brendon/acts_as_list
gem "acts_as_list", "~> 1.2"

# https://github.com/varvet/pundit
gem "pundit", "~> 2.4"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "~> 1.3"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 2.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "~> 1.3"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "~> 1.4"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", "~> 1.2024", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", require: false

# Use Sass to process CSS
gem "sassc-rails", "~> 2.1"

# Abort requests that are taking too long [https://github.com/sharpstone/rack-timeout]
gem "rack-timeout", "~> 0.7.0"

# User authentication [https://github.com/heartcombo/devise]
gem "devise", "~> 4.9"

gem "simple_form", "~> 5.3"

gem "sentry-rails", "~> 5.19"
gem "sentry-ruby", "~> 5.19"

group :development, :test do
  gem "brakeman", "~> 6.2"
  gem "bundler-audit", "~> 0.9.2"

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.9", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails", "~> 3.1"

  # Linting Gems
  gem "rubocop", "~> 1.66"
  gem "rubocop-minitest", "~> 0.36.0"
  gem "rubocop-performance", "~> 1.21"
  gem "rubocop-rails", "~> 2.26"
  gem "rubocop-rake", "~> 0.6.0"

  gem "factory_bot", "~> 6.5"
  gem "factory_bot_rails", "~> 6.4"

  gem "minitest-reporters", "~> 1.7"
  gem "mocha", "~> 2.4"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "~> 4.2"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.40"
  gem "cuprite", "~> 0.15.1"
end
