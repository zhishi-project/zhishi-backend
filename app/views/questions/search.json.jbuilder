json.questions(@questions) do |question|
  json.partial! 'questions/search_result', question: question
end
