class Answer < ActiveRecord::Base
  has_many :comments, as: :comment_on
  belongs_to :user
  belongs_to :question
end
