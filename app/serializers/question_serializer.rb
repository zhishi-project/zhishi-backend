class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :content, :votes_count, :tags, :created_at, :updated_at, :answers_count, :comments_count

  #  has_many :tags, as: :subscriber
end
