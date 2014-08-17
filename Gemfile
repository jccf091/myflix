source 'https://rubygems.org'
ruby "2.1.2"


gem 'unicorn'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'sass-rails', '>= 3.2'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem "pg_search"
gem 'bootstrap_form'
gem 'bcrypt', '~> 3.1.7'
gem "figaro"
gem "titleize"
gem 'roadie'
gem 'roadie-rails'
gem 'masonry-rails'

gem 'sidekiq'
gem 'sinatra', require: false
gem 'carrierwave'
gem 'carrierwave_backgrounder'
gem "mini_magick"
gem "fog"
gem 'metainspector'
gem 'video_info'
gem 'paratrooper'
gem "stripe"
gem 'stripe_event'

group :development do
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'rspec-rails', '2.99'
  gem 'fabrication'
  gem 'faker'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-email'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '2.6.0', require: false
  gem 'database_cleaner', git: 'git@github.com:bmabey/database_cleaner.git'
end

group :production do
  gem 'rails_12factor'
  gem 'informant-rails'
  gem 'newrelic_rpm'
end
