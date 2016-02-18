json.(data, :id, :content, :votes_count, :created_at, :updated_at)
json.partial! 'users/user', user: data.user
