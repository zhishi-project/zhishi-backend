class Question < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  has_many :tags, as: :subscriber
  has_many :answers
  belongs_to :user
  validates :content, presence: true

  include Modify

  class << self
    def with_answers
      includes(:answers)
    end

    def top
      order("votes DESC")
    end

    def add_comment_to_question(question_id, user_id, content)
      question = find_by(id: question_id)
      if question
        question.comments.create(user_id: user_id, content: content)
      end
    end

    def find_question_comment(question_id, id)
      question = find_by(id: question_id)
      if question
        question.comments.where(id: id)
      end
    end

    def delete_question_comment(id, user_id, question_id)
      Modify::Updater.affected_record(question_id, self, user_id).destroy(id)
    end

    def update_question_comment(id, user_id, question_id, attribute, value)
      Modify::Updater.update_subject_comment(id, user_id, question_id, self, attribute, value)
    end
  end
end
