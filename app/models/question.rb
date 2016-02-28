class Question < ActiveRecord::Base
  include VotesCounter
  include ActionView::Helpers::DateHelper

  has_many :comments, as: :comment_on
  has_many :votes, as: :voteable
  has_many :answers
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true
  has_many :resource_tags, as: :taggable
  has_many :tags, through: :resource_tags

  def time_updated
    created = DateTime.parse(created_at.to_s).in_time_zone
    updated = DateTime.parse(updated_at.to_s).in_time_zone

    if (updated - created).to_i > 2
      return distance_of_time_in_words(updated, Time.zone.now) + " ago"
    end

    nil
  end

  def self.with_associations
    eager_load(:votes).eager_load(answers: [{comments: [:user, :votes]}, :user, :votes]).
    eager_load(:user).eager_load(comments: [:user, :votes]).eager_load(:tags)

  end

  def self.with_basic_association
    by_date.includes(:user)
  end

  def tags_to_a
    tags.map(&:name)
  end

  def increment_views
    update(views: views + 1)
  end

  def self.with_answers
    includes(:answers)
  end
end
