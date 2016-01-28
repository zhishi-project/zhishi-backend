class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :votes, :comments, :tags, :answers,
             :created_at, :updated_at, :errors

  has_many :comments, as: :comment_on
  has_many :tags, as: :subscriber
  has_many :answers
end
