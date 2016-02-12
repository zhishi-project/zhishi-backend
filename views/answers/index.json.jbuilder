json.array!(@answers) do |answer|
  json.extract! answer, :id, :user, :content, :votes_count, :created_at, :updated_at, :comments_count
  json.partial! 'application/shared/user', user: answer.user
  json.url question_answer_url(answer.question, answer)
end
