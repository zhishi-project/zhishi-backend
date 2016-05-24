module Notifications
  class NewQuestionSerializer < QuestionSerializer
    attributes :type
    has_many :subscribers

    private
      def type
        'new.question'
      end

      def root
        :notification
      end

      def subscribers
        object.users_subscribed_to_question_tag
      end
  end
end
