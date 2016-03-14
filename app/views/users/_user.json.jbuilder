json.extract! user, :id, :name, :points
json.image user.image
json.url user_url(user, format: :json)
