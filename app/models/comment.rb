class Comment < ActiveRecord::Base
  include VotesCounter
  has_many :votes, as: :voteable
  belongs_to :comment_on, polymorphic: true, counter_cache: true
  belongs_to :user
  validates :content, presence: true
end
