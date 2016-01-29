class Comment < ActiveRecord::Base
  belongs_to :comment_on, polymorphic: true
  belongs_to :user
  validates :content, presence: true
end
