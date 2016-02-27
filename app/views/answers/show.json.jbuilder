json.partial! 'comments/default', data: @answer
json.extract! @answer, :question_id
json.extract! @answer, :comments_count
json.partial! 'users/user', user: @answer.user
json.partial! 'comments/comment', comments: @answer.comments
