source "https://rubygems.org"

ruby "3.1.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "7.1.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# For searching products
gem "pg_search", "~> 2.3.6"

gem "bcrypt", "~> 3.1.7"
gem "money-rails", "~> 1.15"

# SVG, CSS and JS
gem "bootstrap", "~> 5.0"
gem "bootstrap_form", "~> 5.4"
gem "importmap-rails", "~> 1.2"
gem "inline_svg", "~> 1.9.0"
gem "sassc-rails"
gem "jquery-rails"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# profile picture stuff
gem "carrierwave"
gem "mini_magick"

group :rubocop do
  gem "rubocop", "~> 1.56.4", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "standard", require: false
  gem "standard-rails", require: false
end

group :development, :test do
  gem "faker", "~> 3.2.2"
  gem "rspec-rails", "~> 6.0.0"
  gem "simplecov", require: false
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "rails-controller-testing"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end
