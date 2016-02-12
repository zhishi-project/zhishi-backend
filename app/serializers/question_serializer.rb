class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title,:content, :user, :votes_count, :tags, :created_at, :updated_at, :answers_count, :comments_count, :views

  def user
    {
      id: object.user.id,
      name: object.user.name,
      image: object.user.social_providers.first.try(:profile_picture)
    }
  end

  def attributes(*args)
    data = super
    data['answers'] = answers if instance_options[:include_answers]
    data
  end

  def answers
    object.answers.with_votes
  end
end
