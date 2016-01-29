class User < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :tags, as: :subscriber
  has_many :questions
  has_many :answers
  has_many :social_providers

  def self.from_omniauth(auth, user=nil)
    user = where(email: auth.info.email).first_or_create do |u|
      u.name= auth.info.name
      u.email= auth.info.email
    end
    user.social_providers.from_social(auth)
    user
  end

  def refresh_token
    token = TokenManager.generate_token(self.id)
    token
  end

  def self.from_token(token)
    user_token = TokenManager.decode(token)
    user = find_by(id: token[:user])
  end

end



  # social_user = SocialProvider.from_social(auth, user)
  # if social_user.user
  #   social_user.user
  # else
  #
  #   user.social_providers << social_user
  #   user
  # end
#check if email exists
# user = where(email: auth.info.email)
# user = find_by(email: auth.info.email)
# if user.try(:social_providers).try(:pluck, :provider).try(:include?, auth.provider)
#   # user.social_providers
#   user
# else
#
# end
# end


# def self.from_omniauth(auth, user=nil)
#   social_user = SocialProvider.from_social(auth, user)
#   # if social_provider returns a record and the user is set(user exists/old provider)
#   if social_user.user
#     social_user.user
#   else
#     # its a new provider check if the email exists, if not create a new record
#     user = where(email: auth.info.email).first_or_create do |u|
#       u.name= auth.info.name
#       u.email= auth.info.email
#     end
#     # connect social_provider to the user
#     user.social_providers << social_user
#     user
#   end
# end
# end
