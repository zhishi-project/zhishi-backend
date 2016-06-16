json.questions(@questions) do |question|
  json.partial! 'questions/question', question: question
end
json.renewal { json.partial! 'tokens/renewal', token: @token, user: @current_user } if @token
json.partial! "application/shared/pagination", resource: @questions
