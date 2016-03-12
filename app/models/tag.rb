class Tag < ActiveRecord::Base
  include Searchable

  validates :name, presence: true
  has_many :resource_tags
  has_many :questions, through: :resource_tags, source: :taggable, source_type: 'Question'
  has_many :users, through: :resource_tags, source: :taggable, source_type: 'User'

  def self.get_tags_that_are(arg)
    case arg
      when :recent
        all.order("id DESC")
      when :popular
        group(:name).order("count_id DESC").count("id")
      when :trending
        group("name").order("count_id DESC, DATE(created_at) DESC").count("id")
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:name]
    )
  end
end
