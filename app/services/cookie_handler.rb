class CookieHandler
  def self.validate_with_cookie(cookie)
    response = connect.get(ENV['DATA_PATH']) do |request|
      request.headers['Cookie'] = "#{ENV['COOKIE_KEY']}=#{cookie}"
    end

    user_obj = confirm_response(response.body)
    return unless user_obj

    set_user_and_token(user_obj)
  end

  private
  def self.connect
    Faraday.new(ENV['AUTH_URL']) do |conn|
      conn.request  :url_encoded             # form-encode POST params
      conn.response :logger                  # log requests to STDOUT
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def self.set_user_and_token(user_obj)
    user = User.from_andela_auth(user_obj)
    if user.id
      token = TokenManager.generate_token(user.id)
      [user, token]
    end
  end

  def self.confirm_response(response)
    begin
      JSON.parse(response)
    rescue
      false
    end
  end
end
