require 'redis/namespace'

Redis.current = ConnectionPool.new(size: (Sidekiq.server? ? 5 : 1), timeout: 5) do
  Redis::Namespace.new(:zhishi, redis: Redis.new(url: ENV['REDISTOGO_URL']))
end

Sidekiq.configure_server do |config|
  config.redis = Redis.current
  config.average_scheduled_poll_interval = 10
end

Sidekiq.configure_client do |config|
  config.redis = Redis.current
end
