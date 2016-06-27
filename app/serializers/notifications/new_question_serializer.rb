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
  end
end
