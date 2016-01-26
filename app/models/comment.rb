class Comment < ActiveRecord::Base
  has_many :votes, as: :voteable
  belongs_to :comment_on, polymorphic: true
end
