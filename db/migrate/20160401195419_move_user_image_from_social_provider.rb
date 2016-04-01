class MoveUserImageFromSocialProvider < ActiveRecord::Migration
  def up
    User.includes(:social_providers).find_each do |user|
      image = user.social_providers.first.try(:profile_picture)
      user.update(image: image)
    end
  end

  def down
    User.includes(:social_providers).find_each do |user|
      image = user.image
      user.social_providers.first.update(profile_picture: image)
    end
  end
end
