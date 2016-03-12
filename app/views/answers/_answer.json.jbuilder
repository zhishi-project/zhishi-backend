json.extract! answer, :question_id, :comments_count, :id, :content, :votes_count, :created_at, :updated_at
json.user { json.partial! 'users/user', user: answer.user }
json.comments(answer.comments) do |comment|
  json.partial! 'comments/comment', comment: comment
end
