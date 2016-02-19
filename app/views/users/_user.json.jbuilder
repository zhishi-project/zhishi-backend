json.extract! user, :id, :name, :email, :points
json.image user.social_providers.first.try(:profile_picture)
