class User < ActiveRecord::Base
  include AndelaValidator
  include NewNotification
  include ZhishiDateHelper
  include RouteKey

  has_many :comments
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :resource_tags, as: :taggable
  has_many :tags, through: :resource_tags
  has_many :activities, foreign_key: :owner_id
  EMAIL_FORMAT= /(?<email>[.\w-]+@andela).co[m]?\z/
  # /(?<email>[.\w]+@andela).co[m]?\z/

  scope :with_statistics, Queries::StatisticsQuery

  def self.from_andela_auth(user_info)
    user = find_or_initialize_by(email: user_info['email'])

    user.tap{|u| u.update_attributes({name: user_info['name'], image: user_info['image']})}
  end

  def refresh_token
    TokenManager.generate_token(self.id)
  end

  def can_vote?
    points >= 15
  end

  def update_reputation(new_reward)
    new_point = points + new_reward
    new_point = 0 if new_point < 0
    update(points: new_point)
  end

  def subscribe(tag)
    tags << tag
  end

  def member_since
    created_since
  end

  def self.with_associations
    includes(:tags)
  end
end
