class CookieHandler
  def self.validate_with_cookie(cookie)
    response = connect.get(ENV['DATA_PATH']) do |request|
      request.headers['Cookie'] = "#{ENV['COOKIE_KEY']}=#{cookie}"
    end

    confirm_response(response.body)
  end

  def self.logout_cookie(cookie)
    response = connect.get(ENV['LOGOUT_PATH']) do |request|
      request.headers['Cookie'] = "#{ENV['COOKIE_KEY']}=#{cookie}"
    end
  end

  private
  def self.connect
    Faraday.new(ENV['AUTH_URL']) do |conn|
      conn.request  :url_encoded             # form-encode POST params
      conn.response :logger                  # log requests to STDOUT
      conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
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
