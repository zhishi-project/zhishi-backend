json.extract! question, :id, :title, :content
json.user do
  json.extract! question.user, :name, :email
end
json.url question_url(question.id)
