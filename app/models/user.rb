class User < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :tags, as: :subscriber
  has_many :questions
  has_many :answers

  validates :uuid, presence: true
  validates :provider, presence: true

end
