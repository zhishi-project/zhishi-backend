class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title,:content, :user, :votes_count, :tags, :created_at, :updated_at, :answers_count, :comments_count, :views

  belongs_to :user
end
