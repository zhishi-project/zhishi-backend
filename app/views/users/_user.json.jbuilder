json.extract! user, :id, :name, :points, :image
json.partial! 'tags/tag', tags: user.tags
json.url user_url(user, format: :json)
