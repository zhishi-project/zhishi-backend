json.questions(@questions) do |question|
  json.partial! 'questions/question', question: question
end
json.partial! "application/shared/pagination", resource: @questions
