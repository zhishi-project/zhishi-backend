class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title,:content, :votes_count, :tags, :created_at, :updated_at, :answers_count, :comments_count, :views
  belongs_to :user

  def attributes(*args)
    class_eval { has_many :answers } if instance_options[:include_answers]
    super
  end

  def answers
    object.answers.with_votes
  end
end
