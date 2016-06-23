class NotificationQueueWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :notifications, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

  def perform(klass, object_id)
    object = klass.constantize.find(object_id)
    object.distribute_to_notification_queue
  end
end
