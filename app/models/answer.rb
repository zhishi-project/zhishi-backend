class Answer < ActiveRecord::Base
  ACCEPTED_ANSWER_REWARD = 20

  include VotesCounter
  include ModelJSONHashHelper
  include NewNotification

  has_many :comments, as: :comment_on, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  belongs_to :user
  validates :user, presence: true
  belongs_to :question, counter_cache: true, touch: true

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
end
