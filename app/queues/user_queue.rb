class UserQueue < NotificationQueue::BaseQueue
  private
    def notifications
      @user_notification ||= NotificationQueue::Notification.new(self, model_object: NotificationQueue::ZhishiNotificationPresenter)
    end
end
