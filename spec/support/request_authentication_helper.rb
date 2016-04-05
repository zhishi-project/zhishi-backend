module RequestAuthenticationHelper
  def valid_user
    @valid_user ||= create(:user)
  end

  def valid_user_token
    valid_user.refresh_token
  end

  def authorization_header
    {authorization: "Token token=#{valid_user_token}"}
  end
end


RSpec.configure do |config|
  config.include RequestAuthenticationHelper, type: :request
end
