module Notifications
  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :content, :url, :type
    has_one :user
    has_one :question

    private
      def url
        question_answer_url(object.question, object)
      end

      def type
        'Answer'
      end
  end
end
