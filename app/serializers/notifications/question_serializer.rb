module Notifications
  class QuestionSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :tags, :url, :type
    has_one :user

    private
      def url
        question_url(object)
      end

      def tags
        object.tags.pluck(:name)
      end

      def type
        'Question'
      end
  end
end
