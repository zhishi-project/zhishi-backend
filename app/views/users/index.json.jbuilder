json.users(@users) do |user|
  json.partial! "user", user: user
end
# json.renewal { json.partial! 'tokens/renewal', token: @token, user: @current_user } if @token
json.partial! "application/shared/pagination", resource: @users
