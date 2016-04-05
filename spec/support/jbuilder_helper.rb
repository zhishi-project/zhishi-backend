module JBuilderHelper
  extend ActiveSupport::Concern

  included do
    render_views
  end
end

RSpec.configure do |config|
  config.include JBuilderHelper, type: :controller
end
