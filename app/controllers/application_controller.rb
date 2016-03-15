class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user
  before_action :authenticate_user

  def resource_not_found
    not_found = "The resource you tried to access was not found"
    render json: {errors: not_found}, status: 404
  end

  def invalid_request(message = error_msg)
    render json: {errors: message}, status: 400
  end


private
  def authenticate_user
    authenticate_token || unauthorized_token
  end

  def authenticate_token
    authenticate_with_http_token do |auth_token, options|
      user_id = TokenManager.authenticate(auth_token)['user']
      @current_user = User.where(active: true).find_by(id: user_id)
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


  def set_attrs_in_session(hash={})
    hash.each do |key, val|
      session[key] = val
    end
  end

  def get_attrs_from_session(attrs=[])
    vals = []
    attrs.each do |key|
      vals << session[key]
    end
    vals
  end

end
