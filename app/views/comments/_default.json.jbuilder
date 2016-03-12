json.(data, :id, :content, :votes_count, :created_at, :updated_at)
json.user do
  json.partial! 'users/user', user: data.user
end
