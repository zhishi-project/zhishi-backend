json.questions(@questions) do |question|
  json.partial! 'questions/search_result', question: question
end
# json.renewal { json.partial! 'tokens/renewal', token: @token, user: @current_user } if @token
