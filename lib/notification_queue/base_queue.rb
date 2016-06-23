module NotificationQueue
  class BaseQueue
    attr_reader :owner
    cattr_accessor :queue_prefix
    delegate :first, :last, :all, :refresh, :[], to: :notifications

    def initialize(owner)
      @owner = owner
    end

    def queue_name
      @queue_name = namespace_queue_name
    end

    def queue_counter_name
      @queue_counter_name = (queue_name << ":count")
    end

    def notification_count
      notifications.total
    end
    alias_method :total, :notification_count

    def push(notification)
      notifications << notification
    end

    def self.queue_prefix
      @@queue_prefix = Client.namespace
    end

    private
      def notifications
        @user_notification ||= Notification.new(self)
      end

      def namespace_queue_name
        name = ""
        prefix = self.class.queue_prefix
        class_name = self.class.name.demodulize.underscore
        id = owner.id
        name << (prefix.present? ? "#{prefix}:" : '')
        name << "#{class_name}:#{id}"
      end
  end
end
