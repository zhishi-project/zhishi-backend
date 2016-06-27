module Notifications
  class NewCommentSerializer < CommentSerializer
    attributes :type
    has_many :subscribers

    private
      def type
        'new.comment'
      end

      def root
        :notification
      end

      def ancestors
        object.parents
      end
  end
end
