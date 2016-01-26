class Question < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  has_many :tags, as: :subscriber
  has_many :answers
  belongs_to :user
end
