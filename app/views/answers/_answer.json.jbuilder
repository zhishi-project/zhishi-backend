json.answers(answers) do |answer|
  json.partial! 'comments/default', data: answer
  json.extract! answer, :question_id
  json.extract! answer, :comments_count
  json.user do
    json.partial! 'users/user', user: answer.user
  end
  json.partial! 'comments/comment', comments: answer.comments
end
