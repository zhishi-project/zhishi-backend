json.questions(@questions) do |question|
  json.partial! 'questions/question', question: question
end
