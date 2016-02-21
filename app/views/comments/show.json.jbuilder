json.partial! 'comments/default', data: @comment
json.extract! @comment, :comment_on_id, :comment_on_type
