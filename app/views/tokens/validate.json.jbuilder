json.partial! "users/user", user: @user
json.partial! 'tags/tag', tags: @user.tags
json.api_key @user.refresh_token
