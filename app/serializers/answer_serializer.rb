class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :user, :content, :votes_count, :created_at, :updated_at, :comments_count

  def user
    {
      id: object.user.id,
      name: object.user.name,
      email: object.user.points,
      image: object.user.social_providers.first.try(:profile_picture),
      points: object.user.points
    }
  end
end
