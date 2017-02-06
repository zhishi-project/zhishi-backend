json.partial! "user", user: @current_user
json.partial! 'tags/tag', tags: @current_user.tags
json.extract! @current_user, :email, :active, :created_at, :updated_at,:member_since, :token
