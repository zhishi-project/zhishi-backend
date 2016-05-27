class Answer < ActiveRecord::Base
  ACCEPTED_ANSWER_REWARD = 20

  include VotesCounter
  include ModelJSONHashHelper
  include NewNotification
  include UserActivityTracker
  include ZhishiDateHelper
  include RouteKey

  has_many :comments, as: :comment_on, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  belongs_to :user
  belongs_to :question, counter_cache: true, touch: true

  validates :user, presence: true
  validates :question, presence: true
  validates :content, presence: true

  def self.with_associations
    includes(:user).includes(:comments).with_votes
  end

  def as_indexed_json(_options = {})
    self.as_json(
      only: [:content],
      include: user_and_comment_attributes
    )
  end

  def accept
    self.accepted = true
    user.update_reputation(ACCEPTED_ANSWER_REWARD) if changed?
    save
  end

  def sort_value
    accepted ? Float::INFINITY : votes_count
  end

  def create_action_verb
    "Answered a Question"
  end

  def update_action_verb
    "Updated an Answer on a Question"
  end

  def content_that_should_not_cause_update_on_activities
    [:comments_count, :accepted, :updated_at].map(&:to_s)
  end

  def zhishi_url_options
    {
      question_id: question_id,
      id: id
    }
  end
end
