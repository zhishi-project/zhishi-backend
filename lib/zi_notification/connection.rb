require 'faraday'
module ZiNotification
  module Connection
      def self.endpoint
        ENV['ZI_NOTIFICATION_URL']
      end

      def self.connection(token)
        # NOTE we need to also add the authorization once implemented on notifications
        options = {
          headers: {
            'Accept' => 'application/json; charset=utf-8',
            'Authorization' => "Token token=#{token}"
          }
        }

        ::Faraday::Connection.new(endpoint, options) do |connection|
            connection.use ::Faraday::Request::Multipart
            connection.use ::Faraday::Request::UrlEncoded
            connection.response :logger, Rails.logger
            connection.adapter ::Faraday.default_adapter
          end
      end
  end
end
