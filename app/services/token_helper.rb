require 'json/jwt'
require 'pry-rails'
class TokenHelper
  class << self
    def verify_token(token)

      response =  connect.get('/api/v1/fellowship-roles') do |request|
        request.headers['Authorization'] = 'Bearer '+token
      end
      p response

    end

    def connect

      Faraday.new('http://api-staging.andela.com') do |conn|
        conn.request  :url_encoded             # form-encode POST params
        conn.response :logger                  # log requests to STDOUT
        conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
