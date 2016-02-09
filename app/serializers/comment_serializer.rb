class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user, :content, :votes_count, :created_at, :updated_at


  def user
    {
      id: object.user.id,
      name: object.user.name,
      image: object.user.social_providers.first.try(:profile_picture)
    }
  end
end
