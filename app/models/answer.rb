class Answer < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  belongs_to :user
  belongs_to :question
end
