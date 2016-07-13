module QueuePresenters
  class BaseNotificationPresenter
    def initialize
      raise "Cannot initialize an abstract class"
    end

    def question_url
      question_data[:url]
    end

    def question_title
      question_data[:title]
    end

    def fetch_question_from_comment(object)
      comment_parent = object[:type]

      if comment_parent == 'Question'
        object
      elsif comment_parent == 'Answer'
        object[:question]
      end
    end

    def additional_information
      []
    end
  end
end
