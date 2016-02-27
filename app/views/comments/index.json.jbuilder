json.array!(@resource_comments) do |comment|
  json.partial! 'comments/default', data: comment
  json.extract! comment, :comment_on_id, :comment_on_type
end
