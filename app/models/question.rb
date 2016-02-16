class Question < ActiveRecord::Base
  include VotesCounter
  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  has_many :tags, as: :subscriber
  has_many :answers
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true

  include ActionView::Helpers::DateHelper

  def time_updated
    created = DateTime.parse(created_at.to_s).in_time_zone
    updated = DateTime.parse(updated_at.to_s).in_time_zone

    if (updated - created).to_i > 2
      return distance_of_time_in_words(updated, Time.zone.now) + " ago"
    end

    nil
  end

  def increment_views
    update(views: views + 1)
  end

  def self.with_answers
    includes(:answers)
  end
end
