class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user
  helper_method :current_user
  before_action :authenticate_user, except: [:login]

  def resource_not_found
    not_found = "The resource you tried to access was not found"
    render json: {errors: not_found}, status: 404
  end

  def invalid_request(message = error_msg, status = 400)
    render json: {errors: message}, status: status
  end

   def login
     @current_user = authenticate_user
   end

private
   def authenticate_user

     if request.headers['Authorization']
       strategy, token = request.headers['Authorization'].split
       auth = AndelaAuthV2.authenticate(token)

       if strategy == 'Bearer' && auth.authenticated?
         auth_user = auth.current_user
         @current_user = User.find_or_create_by(email: auth_user['email'])
         # we always want to ensure these attrs are in sync with the auth system
         @current_user.update_attributes(
             name: auth_user['name'],
             image: auth_user['picture'],
             active: (auth_user['status'] == 'active')
         )
         @current_user
       else
         unauthorized_token

       end

    else
      unauthorized_token
    end

   end

  def unauthorized_token
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {errors: "Request was made with invalid token"}, status: 401
  end

  def error_msg
    "The operation could not be performed."\
    " Please check your request or try again later"
  end
end
