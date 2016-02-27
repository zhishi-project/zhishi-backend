json.array!(@users) do |user|
  json.partial! "user", user: user
  json.subscriptions user.tags.pluck(:name)
  json.url user_url(user, format: :json)
end
