json.extract! question, :id, :title, :content, :votes_count ,:answers_count, :comments_count, :views, :created_at, :updated_at
json.user { json.partial! 'users/user', user: question.user }
json.url question_url(question)
