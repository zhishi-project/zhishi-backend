require_relative 'andela_auth_v2'

class Authenticator
  attr_reader :request
  attr_accessor :user

  def initialize(request)
    @request = request
  end

  def authenticated?
    if request.headers['Authorization']
      strategy, token = request.headers['Authorization'].split
      auth = AndelaAuthV2.authenticate(token)
      if strategy == 'Bearer' && auth.authenticated?
        return @user = auth.current_user
      else
        return false
      end
    else
      return false
    end
  end
end