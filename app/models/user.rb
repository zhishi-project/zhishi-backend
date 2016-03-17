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

  StatisticsQuery = Struct.new(:user_id) do
    class << self
      delegate :call, to: :new
    end

    attr_reader :relation

    def initialize(relation = User.all)
      @relation = relation
    end

    def user_table
      User.arel_table
    end

    def question_table
      Question.arel_table
    end

    def answers_table
      Answer.arel_table
    end

    def join_associations
      user_table.outer_join(question_table).on(user_table[:id].eq(question_table[:user_id])).
      outer_join(answers_table).on(user_table[:id].eq(answers_table[:user_id])).join_sources
    end

    def questions_asked
      question_table[:id].count.as("questions_asked")
    end

    def answers_given
      answers_table[:id].count.as("answers_given")
    end

    def user_data
      user_table[Arel.star]
    end

    def group_associations
      user_table.group(user_table[:id])
    end

    def call
      relation.joins(joins_associations).select(user_data, questions_asked, answers_given).group("users.id")
    end
  end

  scope :with_statistics, StatisticsQuery

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

  def member_since
    distance_of_time_in_words(created_at, Time.zone.now) + " ago"
  end

  def self.with_associations
    includes(:tags, :social_providers)
  end
end
