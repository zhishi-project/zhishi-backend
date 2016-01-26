class Question < ActiveRecord::Base
  has_many :comments, as: :comment_on
  has_many :tags, as: :subscriber
  has_many :answers
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  def self.top
    where("votes > ?", 0).order("votes DESC")
  end
end
