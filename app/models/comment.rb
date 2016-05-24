class Comment < ActiveRecord::Base
  include VotesCounter
  include ModelJSONHashHelper
  include NewNotification
  include UserActivityTracker
  include ZhishiDateHelper
  include RouteKey

  has_many :votes, as: :voteable, dependent: :destroy
  belongs_to :comment_on, polymorphic: true, counter_cache: true, touch: true
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true
  validates :comment_on, presence: true

  def self.with_associations
    includes(:user).with_votes
  end

  def on_answer?
    comment_on_type == 'Answer'
  end

  def on_question?
    comment_on_type == 'Question'
  end

  def question
    if on_answer?
      comment_on.question
    elsif on_question?
      comment_on
    end
  end

  def as_indexed_json(_options = {})
    self.as_json(
      only: [:content],
      include: user_attributes
    )
  end

  def parents
    comment_parents = [:question]
    comment_parents.push(:comment_on) if on_answer?
    @comment_parents ||= comment_parents.map do |parent|
      send(parent)
    end
  end

  def participants_involved_in_comment
    parents.map(&:user)
  end

  def create_action_verb
    "Commented on #{activity_made_on}"
  end

  def update_action_verb
    "Updated a Comment on #{activity_made_on}"
  end

  def activity_made_on
    %w(a e i o u).include?(comment_on_type.first.downcase) ? "an #{comment_on_type}" : "a #{comment_on_type}"
  end

  def comment_on_klass
    comment_on_type.constantize
  end

  def zhishi_url_options
    {
      resource_name: comment_on_klass.route_key,
      resource_id: comment_on_id,
      id: id
    }
  end
end
