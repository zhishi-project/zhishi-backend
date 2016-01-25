class Comment < ActiveRecord::Base
  belongs_to :comment_on, polymorphic: true
  validates :content, presence: true
end
