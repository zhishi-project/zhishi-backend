class Answer < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  belongs_to :user
  belongs_to :question

  validates :content, presence: true

  include Modify

  class << self
    def add_comment_to_answer(answer_id, user_id, content)
      answer = find_by(id: answer_id)
      if answer
        answer.comments.create(user_id: user_id, content: content)
      end
    end

    def find_answer_comment(answer_id, id)
      answer = find_by(id: answer_id)
      if answer
        answer.comments.where(id: id)
      end
    end

    def delete_answer_comment(id, user_id, answer_id)
      Modify::Updater.affected_record(answer_id, self, user_id).destroy(id)
    end

    def update_answer_comment(id, user_id, answer_id, attribute, value)
      Modify::Updater.update_subject_comment(id, user_id, answer_id, self, attribute, value)
    end
  end

end
