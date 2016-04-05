json.partial! 'questions/question', question: @question
json.partial! 'tags/tag', tags: @question.tags
json.user_vote @question.vote_by(current_user)
json.answers(@question.sort_answers) do |answer|
  json.partial! 'answers/answer', answer: answer
end
json.comments(@question.comments) do |comment|
  json.partial! 'comments/comment', comment: comment
end
