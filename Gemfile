source "https://rubygems.org"

ruby "2.2.3"

gem 'rails', '4.2.5'
gem 'rails-api'
gem 'spring', :group => :development
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-slack'
gem "omniauth-google-oauth2"
gem 'figaro'
gem 'ancestry'
gem 'will_paginate'
gem "puma"
gem "jbuilder"
gem "jwt"
# gem 'unicorn-rails'
gem 'rack-cors'
# for perfomance and monitoring timeout ensures that when a request is taking too long, it is automatically terminated
# new relic provides a dashboard to view the perfomance of our application
gem "rack-timeout"
gem 'newrelic_rpm'


group :development, :test do
  gem "sqlite3"
  gem "rspec-rails"
  gem "pry-rails"
  gem "pry-nav"
  gem "faker"
  gem "factory_girl_rails"
  gem "database_cleaner"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
