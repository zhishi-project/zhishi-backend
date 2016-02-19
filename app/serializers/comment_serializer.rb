class CommentSerializer < MainSerializer
  attributes :user
  belongs_to :user
end
