class NotificationSystemWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :notifications, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Endpoints = ZiNotification::Endpoints

  def perform(klass, object_id)
    object = klass.constantize.find(object_id).object_for_notification.as_json
    ZiNotification::Client.post(Endpoints[:new_resource], object)
  end
end
