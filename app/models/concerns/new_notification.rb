module NewNotification
  extend ActiveSupport::Concern
  included do
    after_create :notify
  end

  def notify
    NotificationSystemWorker.perform_async(model_name.to_s, id)
  end

  def object_for_notification
    klass = model_name.to_s
    serializer = "Notifications::New#{klass}Serializer".constantize
    serializer.new(self).as_json
  end
end
