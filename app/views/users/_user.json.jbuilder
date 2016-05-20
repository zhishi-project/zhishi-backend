json.extract! user, :id, :name, :points, :image
json.url user_url(user, format: :json)
