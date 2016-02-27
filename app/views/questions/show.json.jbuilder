json.partial! 'questions/question', question: @question
json.partial! 'tags/tag', tags: @question.tags_to_a
json.partial! 'answers/answer', answers: @question.answers
json.partial! 'comments/comment', comments: @question.comments
