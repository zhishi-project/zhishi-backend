class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user
  helper_method :current_user
  before_action :authenticate_user#, except: [:login, :logout]

  def resource_not_found
    not_found = "The resource you tried to access was not found"
    render json: {errors: not_found}, status: 404
  end

  def invalid_request(message = error_msg, status = 400)
    render json: {errors: message}, status: status
  end

  # def login
  #   user = authenticate_cookie
  #   @current_user = User.from_andela_auth(user) if user && !user['isGuest']
  #   return unauthorized_token unless @current_user
  #
  #   @token = TokenManager.generate_token(@current_user.id)
  # end

  # def logout
  #   cookie = request.headers['HTTP_ANDELA_COOKIE']
  #   return invalid_request("Cookie must be provided") unless cookie
  #   CookieHandler.logout_cookie(cookie)
  #   render json: {message: 'logged out'}, status: 200
  # end

private
   def authenticate_user
    strategy, token = request.headers['Authorization'].split
    auth = AndelaAuthV2.authenticate(token)

    # during refactor these methods/checks should be moved out of here
    if strategy == 'Bearer' && auth.authenticated?
      auth_user = auth.current_user
      @current_user = User.find_or_create_by(email: auth_user['email'])
      # we always want to ensure these attrs are in sync with the auth system
      @current_user.update_attributes(
        name: auth_user['name'],
        image: auth_user['picture'],
        active: (auth_user['status'] == 'active')
      )
    else
      unauthorized_token
    end

   end
  # def authenticate_user
  #   (authenticate_token && authenticate_cookie) || unauthorized_token
  #   # authenticate_cookie || unauthorized_token
  # end

  # def authenticate_token
  #   authenticate_with_http_token do |auth_token, _|
  #     user_id = TokenManager.authenticate(auth_token)['user']
  #     @token = TokenManager.generate_token(user_id) if user_id
  #   end
  # end

  # def authenticate_cookie
  #   cookie = request.headers['HTTP_ANDELA_COOKIE']
  #   return unless cookie
  #   user = CookieHandler.validate_with_cookie(cookie)
  #   @current_user = User.find_by(email: user['email']) if user
  #   user
  # end

  def unauthorized_token
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {errors: "Request was made with invalid token"}, status: 401
  end

  def error_msg
    "The operation could not be performed."\
    " Please check your request or try again later"
  end
end
