class NotificationSystemWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :notifications, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
  Endpoints = ZiNotification::Endpoints

  def perform(klass, object_id)
    object = klass.constantize.find(object_id).object_for_notification
    token = TokenManager.generate_token(nil, 5.minutes.from_now, object)
    options = { object: object, json_token: token }
    ZiNotification::Client.post(Endpoints[:new_resource], options)
  end
end
