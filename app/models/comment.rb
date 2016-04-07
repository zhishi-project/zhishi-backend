class Comment < ActiveRecord::Base
  include VotesCounter
  include ModelJSONHashHelper

  has_many :votes, as: :voteable, dependent: :destroy
  belongs_to :comment_on, polymorphic: true, counter_cache: true, touch: true
  belongs_to :user
  validates :user, presence: true
  validates :content, presence: true

  def self.with_associations
    includes(:user).with_votes
  end

  def question
    if comment_on_type == 'Answer'
      comment_on.question
    else
      comment_on
    end
  end

  def as_indexed_json(_options = {})
    self.as_json(
      only: [:content],
      include: user_attributes
    )
  end
end
