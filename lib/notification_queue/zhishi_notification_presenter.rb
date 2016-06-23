module NotificationQueue
  class ZhishiNotificationPresenter
    attr_reader :notification_object, :type, :key, :id, :url, :content
    delegate :[], to: :notification_object

    def initialize(obj)
      @notification_object = obj
      deserialize_attributes
    end

    def deserialize_attributes
      @id = notification_object[:payload][:id]
      @url = notification_object[:payload][:url]
      @content = notification_object[:payload][:content]
      @type = notification_object[:type]
      @key = notification_object[:key]
    end

    def question_data
      @question_object ||= case type_klass
      when 'Question'
        notification_object[:payload]
      when 'Answer'
        notification_object[:payload][:question]
      when 'Comment'
        fetch_question_from_comment(notification_object[:payload][:parent])
      end
    end

    def question_url
      question_data[:url]
    end

    def question_title
      question_data[:title]
    end

    def type_klass
      keys = {
        'new.comment' => 'Comment',
        'new.answer' => 'Answer',
        'new.question' => 'Question'
      }
      keys[key]
    end

    def fetch_question_from_comment(object)
      comment_parent = object[:type]

      if comment_parent == 'Question'
        object
      elsif comment_parent == 'Answer'
        object[:question]
      end
    end
  end
end
