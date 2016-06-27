class UserVotesQueue < NotificationQueue::BaseQueue
  private
    def notifications
      @user_notification ||= NotificationQueue::Notification.new(self, model_object: QueuePresenters::ZhishiVotesNotificationPresenter)
    end
end
