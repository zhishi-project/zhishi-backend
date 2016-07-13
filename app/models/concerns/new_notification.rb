module NewNotification
  extend ActiveSupport::Concern
  included do
    after_create :notify
  end

  def notify
    NotificationSystemWorker.perform_in(5.seconds, model_name.to_s, id)
  end

  def serialized_notification_object
    klass = model_name.to_s
    serializer = "Notifications::New#{klass}Serializer".constantize
    serializer.new(self)
  end

  def object_for_notification
    serialized_notification_object.as_json
  end
end
