Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.auto_notify = begin
    if ENV['NOTIFY_BUG_SNAG'] == 'true'
      true
    else
      false
    end
  end
end
