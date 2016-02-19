class Answer < ActiveRecord::Base
  include VotesCounter
  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  belongs_to :user
  validates :user, presence: true
  belongs_to :question, counter_cache: true

  validates :content, presence: true
end
