module NotificationQueueResource
  extend ActiveSupport::Concern

  included do
    after_create :update_notification_queue_with_sidekiq
  end

  def update_notification_queue_with_sidekiq
    NotificationQueueWorker.perform_in(5.seconds, model_name.to_s, id)
  end

  def distribute_to_notification_queue
    serialized_notification_object.subscribers.each do |subscriber|
      subscriber.push_to_queue(self) unless subscriber == user
    end
  end

  def queue_tracking_info
    {
      type: "New #{self.class}",
      key: "new.#{model_name.param_key}",
      payload: serialized_notification_queue_object.as_json
    }
  end

  def queue_tracking_info_json
    queue_tracking_info.to_json
  end

  def serialized_notification_queue_object
    klass = model_name.to_s
    serializer = "Notifications::#{klass}Serializer".constantize
    serializer.new(self, root: false)
  end
end
