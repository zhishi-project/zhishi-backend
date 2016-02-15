class AnswerSerializer < MainSerializer
  attributes :question_id, :comments_count, :comments
  has_many :comments
end
