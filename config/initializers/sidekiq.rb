Redis.current = ConnectionPool.new(size: (Sidekiq.server? ? 5 : 1), timeout: 5) do
  Redis.new(url: ENV['REDISTOGO_URL'])
end

Sidekiq.configure_server do |config|
  config.redis = Redis.current
end

Sidekiq.configure_client do |config|
  config.redis = Redis.current
end
