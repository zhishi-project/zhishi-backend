module ZiNotification
  # NOTE we still need to implement other interfaces to the different notifications actions
  module Client
    class << self
      [:post, :get, :put, :delete].each do |http_method|
        define_method http_method do |path, options = {}|
          request(http_method, path, options)
        end
      end

      def request(http_method, path, options)
        ZiNotification::Connection.connection.send(http_method, path, options)
      end
    end
  end
end
