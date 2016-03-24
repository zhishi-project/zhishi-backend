class Tag < ActiveRecord::Base
  include Searchable

  validates :name, presence: true
  has_many :resource_tags
  has_many :questions, through: :resource_tags, source: :taggable, source_type: 'Question'
  has_many :users, through: :resource_tags, source: :taggable, source_type: 'User'

  has_many :similar_tags, class_name: 'Tag', foreign_key: "representative_id"
  belongs_to :representative, class_name: 'Tag'

  # before_create :assign_representative

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

  def self.process_tags(new_tags)
    new_tags = new_tags.split(",")
    new_tags.map{ |tg| where("name LIKE ? ", tg.downcase).find_or_initialize_by(name: tg) }
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:name]
    )
  end

  def assign_representative
    rep  = Tag.search(self.name).first
    self.representative = rep.representative_id || rep.id
  end
end
