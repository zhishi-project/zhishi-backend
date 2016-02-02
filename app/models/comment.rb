class Comment < ActiveRecord::Base
  has_many :votes, as: :voteable
  belongs_to :comment_on, polymorphic: true
  belongs_to :user
  validates :content, presence: true
end
