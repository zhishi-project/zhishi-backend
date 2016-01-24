class Comment < ActiveRecord::Base
  belongs_to :comment_on
end
