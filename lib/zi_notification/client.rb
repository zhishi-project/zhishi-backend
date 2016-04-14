module ZiNotification
  # NOTE we still need to implement other interfaces to the different notifications actions
  module Client
    class << self
      def post(path, options = {})
        request(:post, path, options)
      end

      def get(path, options = {})
        request(:get, path, options)
      end

      def put(path, options = {})
        request(:put, path, options)
      end

      def delete(path, options = {})
        request(:delete, path, options)
      end

      def request(method, endpoint, options)
        ZiNotification::Connection.connection.send(method, endpoint, options)
      end
    end
  end
end
