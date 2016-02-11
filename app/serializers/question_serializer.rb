class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :votes_count, :tags, :created_at, :updated_at, :answers_count, :comments_count, :views

  def user
    {
      id: object.user.id,
      name: object.user.name,
      image: object.user.social_providers.first.try(:profile_picture)
    }
  end
end
