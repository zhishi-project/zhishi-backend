class CookieHandler

  AUTH_URL = 'http://authentication.andela.com/'
  DATA_PATH = 'loggedin'
  COOKIE_KEY = 'andela:session'

  def self.validate_with_cookie(cookie)
    response = connect.get(DATA_PATH) do |request|
      request.headers['Cookie'] = "#{COOKIE_KEY}=#{cookie}"
    end

    begin
      extract_user_and_token(response)
    rescue JSON::ParserError => e
      false
    end
  end

  private
  def self.connect
    @connection ||= Faraday.new(AUTH_URL) do |conn|
      conn.request  :url_encoded             # form-encode POST params
      conn.response :logger                  # log requests to STDOUT
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def self.extract_user_and_token(response)
    user = JSON.parse(response.body)
    user = User.from_andela_auth(user)
    token = TokenManager.generate_token(user.id)
    [user, token]
  end
end
