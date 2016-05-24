require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zhishi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += [config.root.join('app', 'presenters'), config.root.join('db', 'helpers')]
    # $: << Rails.root.join('app', 'presenters')
    # config.autoload_paths += %W( #{config.root}/workers )
    config.autoload_paths += [config.root.join('lib')]
    Dir[config.root.join('lib', '**', '*.rb')].each do |path|
      config.autoload_paths += [path]
    end
    # Rails.application.
    routes.default_url_options[:host] = ENV['BASE_URL'] #'localhost:3000'

    config.middleware.insert_after(ActiveRecord::QueryCache, ActionDispatch::Cookies)
    config.middleware.insert_after(ActionDispatch::Cookies, ActionDispatch::Session::CookieStore)
  end
end
