json.comments do
  json.array!(@resource_comments) do |comment|
    json.partial! 'comment', comment: comment
  end
end

json.renewal { json.partial! 'tokens/renewal', token: @token, user: @current_user } if @token
