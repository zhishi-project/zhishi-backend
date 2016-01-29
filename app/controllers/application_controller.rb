class ApplicationController < ActionController::API



private
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

  def unauthorized_token
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {errors: "Request was made with invalid token"}, status: 401
  end

  def resource_not_found
    render json: {errors: "The resource you tried to access was not found"}, status: 404
  end

  def set_attrs_in_session(hash={})
    hash.each{ |key, val|
      session[key] = val
    }
  end

  def get_attrs_from_session(attrs=[])
    vals = []
    attrs.each{ |key|
      vals << session[key]
    }
    vals
  end

end
