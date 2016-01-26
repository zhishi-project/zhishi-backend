class SocialProvider < ActiveRecord::Base
  belongs_to :user

  def self.from_social(auth, user=nil)
    social_user = where(uuid: auth.uid, provider: auth.provider).first_or_create do |sp|
      sp.token= auth.credentials.token
      sp.refresh_token= auth.credentials.refresh_token
      sp.uuid= auth.uid
      sp.profile_picture = auth.info.image
      url_for_profile = auth.info.urls
      sp.profile_url = url_for_profile[:Facebook] || url_for_profile[:Google] || url_for_profile[:Twitter] || url_for_profile[:LinkedIn] || url_for_profile[:public_profile]
      sp.profile_email = auth.info.email
    end
    social_user.update(user: user) if user && social_user.user.blank?
    social_user

    # user = User.find_by(email: social_user.profile_email)
  end
end
