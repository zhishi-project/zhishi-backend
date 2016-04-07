json.extract! comment, :id, :content, :votes_count, :created_at, :updated_at, :comment_on_id, :comment_on_type
json.user_vote comment.vote_by(current_user)
json.user { json.partial! 'users/user', user: comment.user }
