class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user, :content, :votes_count, :created_at, :updated_at

  belongs_to :user
end
