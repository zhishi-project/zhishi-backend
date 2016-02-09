class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :content, :votes, :comments, :tags, :answers,
             :created_at, :updated_at, :votes_count, :answers_count, :views_count,
             :time_updated, :user

  has_many :comments, as: :comment_on
  has_many :tags, as: :subscriber
  has_many :answers

  def votes_count
    object.votes.count
  end

  def answers_count
    object.answers.count
  end

  def views_count
    object.views
  end

  def user
    {
      name: object.user.name,
      image: object.user.social_providers.first.profile_picture
    }
  end
end
