class ApplicationController < ActionController::API
  def current_user
    @current_user || authenticate_token
  end

  def authenticate_token
    payload, _header = TokenManager.authenticate(request)
    if payload
      @current_user = User.find_by(id: payload["user"])
      return @current_user if @current_user && @current_user.active
    end
    head 401, content_type: "application/json"
  end
end
