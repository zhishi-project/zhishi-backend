class User < ActiveRecord::Base
  include AndelaValidator
  include ActionView::Helpers::DateHelper
  has_many :comments
  has_many :questions
  has_many :answers
  has_many :social_providers
  has_many :tokens
  has_many :votes
  has_many :resource_tags, as: :taggable
  has_many :tags, through: :resource_tags
  EMAIL_FORMAT= /(?<email>[.\w]+@andela).co[m]?\z/

  scope :with_statistics, Queries::StatisticsQuery

  def self.from_omniauth(auth)
    email_address = auth.info.email
    grabbed = EMAIL_FORMAT.match(email_address).try(:[], :email)
    grabbed = grabbed ? "#{grabbed}%" : email_address
    user = where("email LIKE :email", email: grabbed).first_or_create do |u|
      u.name= auth.info.name
      u.email= auth.info.email
    end
    return user unless user.valid?
    user.social_providers.from_social(auth)
    user
  end

  def refresh_token
    TokenManager.generate_token(self.id)
  end

  def image
    social_providers.first.try(:profile_picture)
  end

  def can_vote?
    points >= 15
  end

  def update_user_reputation(new_reward)
    new_point = points + new_reward
    new_point = 0 if new_point < 0
    update(points: new_point)
  end

  def subscribe(tag)
    tags << tag
  end

  def member_since
    distance_of_time_in_words(created_at, Time.zone.now) + " ago"
  end

  def self.with_associations
    includes(:tags, :social_providers)
  end
end
