json.partial! 'questions/question', question: @question
json.partial! 'tags/tag', tags: @question.tags_to_a
json.partial! 'answers/answer', answers: @question.answers
# require 'pry' ; binding.pry
json.partial! 'comments/comment', comments: @question.comments
