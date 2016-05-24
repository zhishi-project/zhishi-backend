require 'public_activity/testing'

PublicActivity.enabled = false
RSpec.configure do |config|
  config.around(:each, track_activity: true) do |example|
    PublicActivity.with_tracking do
      example.run
    end
  end
end
