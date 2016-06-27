class Question < ActiveRecord::Base
  include VotesCounter
  include ZhishiDateHelper
  include Searchable
  include ModelJSONHashHelper
  include NewNotification
  include UserActivityTracker
  include RouteKey
  include NotificationQueueResource

  has_many :comments, as: :comment_on, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :resource_tags, as: :taggable
  has_many :tags, through: :resource_tags
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true
  has_many :resource_tags, as: :taggable
  has_many :tags, through: :resource_tags
  has_many :associated_resource_activities, class_name: "Activity", foreign_key: "recipient_id"
  after_update :update_associated_resource_activities, if: :should_create_activity?

  def time_updated
    created = DateTime.parse(created_at.to_s).in_time_zone
    updated = DateTime.parse(updated_at.to_s).in_time_zone

    if (updated - created).to_i > 2
      return updated_since
    end

    nil
  end

  def self.order_by_user_subscription(user)
    Queries::OrderBySubscriptionQuery.new(user).call
  end

  def self.eager_load_basic_association
    # NOTE this was prompted because after using the AR#includes, it appears there was an N+1
    # query to fetch all tags OR votes(note OR). This is wierd and needs a little bit more research as to the behaviour
    eager_load(:votes).eager_load(:tags).with_votes.with_users.group("votes_questions.id", "tags.id", "users.id", "social_providers.id")
  end

  def self.personalized(user)
    Queries::UserQuestionsQuery.new(user).call
  end

  def self.with_associations
    eager_load(:votes)
      .eager_load(answers: [{comments: [{user: [:social_providers]}, :votes]}, {user: [:social_providers]}, :votes])
      .eager_load(user: [:social_providers])
      .eager_load(comments: [{user: [:social_providers]}, :votes])
      .eager_load(:tags)
      .order('answers.accepted DESC')

  end

  def self.with_basic_association
    by_date.with_users
  end

  def self.with_users
    includes(user: [:social_providers])
  end

  def increment_views
    increment!(:views)
  end

  def self.with_answers
    includes(:answers)
  end

  def self.by_tags(tag_ids)
    # tag_ids = tag_ids.map(&:to_i)
    Queries::QuestionFilterQuery.new(tag_ids: tag_ids, relation: self).call
  end

  def as_indexed_json(_options = {})
    self.as_json(
      only: content_for_index,
      include: { tags: { only: :name},
                 comments: {
                   only: [:content],
                   include: user_attributes
                 },
                 answers: {
                   only: [:content],
                   include: user_and_comment_attributes
                 },
               }.merge(user_attributes)
    )
  end

  def users_subscribed_to_question_tag
    Queries::TagsSubscriberQuery.new(self).call
  end

  def content_for_index
    [:title, :content, :comments_count, :answers_count, :views]
  end

  def content_that_should_not_be_indexed
    [:views, :updated_at].map(&:to_s)
  end

  def sort_answers
    answers.sort do |a, b|
      b.sort_value <=> a.sort_value
    end
  end

  def create_action_verb
    "Asked a Question"
  end

  def update_action_verb
    "Updated a Question"
  end

  def tracking_information
    [:id, :title, :content, :created_since]
  end

  def update_associated_resource_activities
    associated_resource_activities.update_all(parameters: { related_information: related_information})
  end

  def related_information
      {
        type: "Question",
        id: id,
        title: title,
        content: content,
        user_id: user_id,
        tags: tags.map{ |t|
          {
            id: t.id,
            name: t.name,
            representative_id: t.representative_id
          }
        }
      }
  end

  def content_that_should_not_cause_update_on_activities
    content_that_should_not_be_indexed.push(:comments_count, :answers_count).map(&:to_s)
  end

  def zhishi_url_options
    {
      id: id
    }
  end

  def subscribers
    [*users_subscribed_to_question_tag]
  end
end
