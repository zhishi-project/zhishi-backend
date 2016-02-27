json.partial! "users/user", user: @user
json.api_key @user.refresh_token
