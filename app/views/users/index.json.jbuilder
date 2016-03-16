json.users(@users) do |user|
  json.partial! "user", user: user
end
json.partial! "application/shared/pagination", resource: @users
