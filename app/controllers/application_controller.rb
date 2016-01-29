class ApplicationController < ActionController::API
  # before_action :authenticate

  private


    def authenticate
      authenticate_token || unauthorized_token
    end

    def authenticate_token
      authenticate_with_http_token do |auth_token, options|
        @current_user ||= User.from_token(auth_token)
      end
    end

    def unauthorized_token
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: {errors: "Request was made with invalid token"}, status: 401
    end

    def resource_not_found
      render json: {errors: "The resource you tried to access was not found"}, status: 404
    end
end
