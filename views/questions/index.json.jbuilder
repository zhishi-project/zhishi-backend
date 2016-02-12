json.array!(@questions) do |question|
  json.extract! question, :id, :title, :content, :votes_count, :tags, :created_at, :updated_at, :answers_count, :comments_count, :views
  json.partial! 'application/shared/user', user: question.user
  json.url question_url(question)
end
