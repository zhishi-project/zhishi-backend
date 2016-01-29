source 'https://rubygems.org'

ruby "2.2.3"

gem 'rails', '4.2.5'
gem 'rails-api'
gem 'spring', :group => :development
# gem 'omniauth-oauth2', '~> 1.3.1'
# gem 'omniauth-slack'
# gem "omniauth-google-oauth2"
gem 'figaro'
gem 'ancestry'
gem "active_model_serializers", "~> 0.8.0"
gem "jwt"


group :development, :test do
  gem 'sqlite3'
  gem "rspec-rails"
  gem 'pry-rails'
  gem 'pry-nav'
  gem "faker"
end

group :production do
  gem 'pg'
end
