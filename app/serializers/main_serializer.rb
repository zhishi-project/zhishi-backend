class MainSerializer < ActiveModel::Serializer
  attributes :id, :content, :votes_count, :voted, :created_at, :updated_at, :user

  def voted
    object.votes.voted?(object.class.to_s, object.id, object.user)
  end

  def user
    {
      id: object.user.id,
      name: object.user.name,
      email: object.user.email,
      image: object.user.social_providers.first.try(:profile_picture),
      points: object.user.points
    }
  end
end
