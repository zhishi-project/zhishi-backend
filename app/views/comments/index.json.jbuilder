json.array!(@resource_comments) do |comment|
  json.partial! 'comment', comment: comment
end
