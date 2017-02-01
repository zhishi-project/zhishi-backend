class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user
  helper_method :current_user
  before_action :authenticate_user

  def invalid_request(message = error_msg, status = 400)
    render json: {errors: message}, status: status
  end

private
   def authenticate_user
     auth = Authenticator.new(request)
     if auth.authenticated?
       create_or_update_user(auth.user)
     else
       unauthorized_token
     end
   end

  def create_or_update_user(user)
    @current_user = User.find_or_create_by(email: user['email'])
    # we always want to ensure these attrs are in sync with the auth system
    @current_user.update_attributes(
        name: user['name'],
        image: user['picture'],
        active: (user['status'] == 'active')
    )
    @current_user
  end

  def unauthorized_token
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {errors: "Request was made with invalid token"}, status: 401
  end

  def resource_not_found
    not_found = "The resource you tried to access was not found"
    render json: {errors: not_found}, status: 404
  end

  def error_msg
    "The operation could not be performed."\
    " Please check your request or try again later"
  end
end
