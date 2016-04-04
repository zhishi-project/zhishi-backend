module ValidRequest
  def valid_user
    @valid_user ||= create(:user)
  end

  extend ActiveSupport::Concern
  included do
    before(:each, valid_request: true) do
      request.headers['Authorization'] = "Token token=#{valid_user.refresh_token}"
    end
  end
end

RSpec.configure do |config|
  config.include ValidRequest, type: :controller
end
