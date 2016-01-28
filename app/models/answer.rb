class Answer < ActiveRecord::Base
  has_many :comments, as: :comment_on
  belongs_to :user
  belongs_to :question

  validates :content, presence: true

  include Modify

  class << self
    def add_comment_to_answer(answer_id, user_id, content)
      find_by(id: answer_id).comments.
        create(user_id: user_id, content: content)
    end

    def find_answer_comment(answer_id, id)
      find_by(id: answer_id).comments.where(id: id)
    end

    def delete_answer_comment(user_id, answer_id, id)
      Modify::Updater.affected_record(answer_id, self, user_id).destroy(id)
    end

    def update_answer_comment(id, user_id, answer_id, attribute, value)
      Modify::Updater.update_subject_comment(id, user_id, answer_id, self, attribute, value)
    end
  end

end
