class Tag < ActiveRecord::Base
  include Searchable

  validates :name, presence: true
  has_many :resource_tags
  has_many :questions, through: :resource_tags, source: :taggable, source_type: 'Question'
  has_many :users, through: :resource_tags, source: :taggable, source_type: 'User'

  has_many :similar_tags, class_name: 'Tag', foreign_key: 'representative_id'
  belongs_to :representative, class_name: 'Tag'

  before_save :downcase!, :strip!
  after_create :push_representative_assignment_to_sidekiq
  after_update :push_subscription_update_to_sidekiq, if: :representative_id_changed?

  class << self
    def get_tags_that_are(arg)
      case arg
      when :recent
        all.order('id DESC')
      when :popular
        group(:name).order('count_id DESC').count('id')
      when :trending
        group('name').order('count_id DESC, DATE(created_at) DESC').count('id')
      end
    end

    def process_tags(new_tags)
      analyze_tags(new_tags).map do |tag_name|
        tag_name = tag_name.strip.downcase
        where(name: tag_name).first_or_initialize
      end
    end

    def resolution_for(tag_name)
      {
        query: {
          filtered: {
            query: { match: { name: tag_name } },
            filter: {
              missing: { field: :representative_id }
            }
          }
        }
      }
    end

    private
    # TODO create a seperate class that does the processing of params, something like ArrayProcessor that would always return array of objects.
      def analyze_tags(tag_params)
        if tag_params.is_a? Array
          tag_params
        elsif tag_params.is_a? String
          tag_params.split(',')
        else
          []
        end
      end
  end

  def strip!
    name.strip!
  end

  def downcase!
    name.downcase!
  end

  def as_indexed_json(_options = {})
    as_json(
      only: [:name, :representative_id]
    )
  end

  def push_representative_assignment_to_sidekiq
    TagRepresentativeAssignmentWorker.perform_async(id, name)
  end

  def push_subscription_update_to_sidekiq
    TagSubscriptionReassignmentWorker.perform_async(id)
  end

  def update_tag_subscriptions
    resource_tags.remap_to_tag_parent(representative || self)
  end

  def update_parent(representative)
    update(representative: representative)
  end

  private
    def search_resolution
      Tag.resolution_for(name)
    end

    def content_that_should_not_be_indexed
      [:created_at, :updated_at].map(&:to_s)
    end
end
