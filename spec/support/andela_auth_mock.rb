module AndelaAuthMock
  extend ActiveSupport::Concern

  require 'webmock/rspec'
  WebMock.disable_net_connect!(allow_localhost: true)

  included do
    before(:each) do
      stub_authorized_user_auth
      stub_unauthorized_user_auth
    end
  end

  def auth_server
    Connection::FaradayConnection::BASE_ANDELA_URL + "/api/v1/users/me"
  end

  def stub_authorized_user_auth
    stub_request(:get, auth_server).with(headers: authorization_header).
      to_return(body: Notifications::UserSerializer.new(valid_user, root: false).to_json)
  end

  def stub_unauthorized_user_auth
    stub_request(:get, auth_server).with(headers: unauthorized_token).
      to_return(status: 401, body: {error: true}.to_json)
  end

  def authorization_header
    { Authorization: "Bearer samplebearertokencanbefoundhere" }
  end

  def unauthorized_token
    { Authorization: "Bearer whatever"}
  end

  def valid_user
    @valid_user ||= create(:user)
  end

  module AuthControllerHelper
    extend ActiveSupport::Concern

    RSpec.configure do |config|
      config.include self
    end

    included do
      before(:each, valid_request: true, type: :controller) do
        request.headers["Authorization"] = "Bearer samplebearertokencanbefoundhere"
      end

      before(:each, invalid_request: true, type: :controller) do
        request.headers["Authorization"] = "Bearer whatever"
      end

    end


  end

  RSpec.configure do |config|
    config.include self, type: :request
    config.include self, type: :controller
  end
end