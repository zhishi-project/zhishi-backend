module NotificationQueue
  class Client
    cattr_accessor :client, :namespace

    class << self
      def client
        @@client ||= default_configuration
      end


      def configure(&block)
        yield self
      end

      def sweep

      end

      private
        def default_configuration
          Redis::Namespace.new(:zhishi, redis: Redis.new(url: ENV['REDISTOGO_URL']))
        end
    end
  end
end
