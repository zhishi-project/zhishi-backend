class User < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :tags, as: :subscriber
  has_many :questions
  has_many :answers
  has_many :social_providers
  has_many :tokens
  EMAIL_FORMAT= /(?<email>[.\w]+@andela).co[m]?\z/

  def self.from_omniauth(auth, user=nil)
    email_address = auth.info.email
    grabbed = EMAIL_FORMAT.match(email_address).try(:[], :email) || email_address
    to_check = "#{grabbed}%"
    user = where(email: to_check).first_or_create do |u|
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
    user = find_by(id: user_token['user'])
  end

end
