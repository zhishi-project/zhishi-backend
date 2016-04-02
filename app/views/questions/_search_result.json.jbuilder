json.extract! question, :id, :title, :content, :comments_count, :answers_count, :views
json.user do
  json.extract! question.user, :name, :email
end
json.url question_url(question.id)
