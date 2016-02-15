class QuestionSerializer < MainSerializer
  attributes :title, :tags, :answers_count, :comments_count, :views

  def attributes(*args)
    class_eval { has_many :answers } if instance_options[:include_answers]
    super
  end

  def answers
    object.answers.with_votes
  end
end
