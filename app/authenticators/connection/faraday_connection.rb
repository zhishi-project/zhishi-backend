class Connection::FaradayConnection
  BASE_ANDELA_URL =  "http://api-staging.andela.com" # use env variable to set the url

  def self.connection(token)
    options = {
      headers: {
        "Authorization" => "Bearer #{token}",
        "Accept" => 'application/json; charset=utf-8',
      },
      ssl: {
        verify: false
      }
    }

    ::Faraday::Connection.new(BASE_ANDELA_URL, options) do |conn|
      conn.use ::Faraday::Request::Multipart
      conn.use ::Faraday::Request::UrlEncoded
      conn.use FaradayMiddleware::FollowRedirects
      conn.response :logger, Rails.logger
      conn.adapter ::Faraday.default_adapter
    end
  end
end
