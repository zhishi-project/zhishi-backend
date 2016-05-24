module Notifications
  class NewUserSerializer < UserSerializer
    attributes :type
    has_many :subscribers

    private
      def root
        :notification
      end

      def type
        'new.user'
      end

      def subscribers
        [object]
      end
  end
end
