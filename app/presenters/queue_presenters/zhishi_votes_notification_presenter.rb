module QueuePresenters
  class ZhishiVotesNotificationPresenter < BaseNotificationPresenter
    attr_reader :notification_object, :vote_type, :key, :url, :content
    delegate :[], to: :notification_object

    def initialize(obj)
      @notification_object = obj
      deserialize_attributes
    end

    def type
      "#{inflected_vote_type.capitalize} your #{voteable_type}"
    end

    def url
      question_url
    end

    def points
      {
        "question.upvote" => "+5",
        "answer.upvote" => "+5",
        "comment.upvote" => "+2",
        "question.downvote" => "-2",
        "answer.downvote" => "-2",
        "comment.downvote" => "0",
        "answer.accept" => "+20"
      }[key]
    end

    def id
      voteable[:id]
    end

    def question_url
      question_data[:url]
    end

    def question_title
      question_data[:title]
    end

    def content
      voteable[:content]
    end

    def additional_information
      [:points]
    end

    private
      def voteable_type
        voteable[:type]
      end

      def voteable
        @parent ||= notification_object[:payload][:vote_on]
      end
      def inflected_vote_type
        if ['upvote', 'downvote'].include?(vote_type)
          vote_type << 'd'
        elsif vote_type == 'accept'
          vote_type << 'ed'
        end
      end

      def question_data
        @question_data ||= case voteable_type
        when 'Question'
          voteable
        when 'Answer'
          voteable[:question]
        when 'Comment'
          fetch_question_from_comment(voteable[:parent])
        end
      end

      def deserialize_attributes
        @vote_type = notification_object[:payload][:vote_type]
        @type = notification_object[:type]
        @key = notification_object[:key]
      end
  end
end
