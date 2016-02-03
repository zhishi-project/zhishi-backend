class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :content, :votes, :comments, :tags, :answers,
             :created_at, :updated_at

   has_many :comments, as: :comment_on
   has_many :tags, as: :subscriber
   has_many :answers
end
