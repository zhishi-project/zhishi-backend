module NotificationQueueConfiguration
  RSpec.configure do |config|
    config.include self, type: :notifications_queue

    config.around(:each, namespaced: false) do |example|
      prefix = NotificationQueue::Client.namespace
      NotificationQueue::Client.namespace = false

      example.run

      NotificationQueue::Client.namespace = prefix
    end
  end
end
