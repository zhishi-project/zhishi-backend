json.partial! "user", user: @user
json.extract! @user, :active, :created_at, :updated_at
json.subscriptions @user.tags.pluck(:name)
