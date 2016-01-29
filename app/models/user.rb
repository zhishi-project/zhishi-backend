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
