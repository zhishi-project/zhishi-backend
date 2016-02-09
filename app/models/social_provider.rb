class SocialProvider < ActiveRecord::Base
  include AndelaValidator
  belongs_to :user
  validates :uuid, presence: true
  validates :provider, presence: true

  def self.from_social(auth, user=nil)
    social_user = where(uuid: auth.uid, provider: auth.provider).first_or_create do |sp|
      sp.token= auth.credentials.token
      sp.refresh_token= auth.credentials.refresh_token
      sp.uuid= auth.uid
      sp.profile_picture = auth.info.image
      url_for_profile = auth.info.urls || {}
      sp.profile_url = url_for_profile[:Google] || url_for_profile[:Slack] || url_for_profile[:public_profile]
      sp.email = auth.info.email
    end
    social_user.update(user: user) if user && social_user.user.blank?
    social_user
  end
end
