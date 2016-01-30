class Tag < ActiveRecord::Base
  belongs_to :subscriber, polymorphic: true

  validates :name, presence: true
  validates :subscriber_id, presence: true

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

  scope :search, -> (arg) do
    val = arg ? where(arel_table[:name].matches("%#{arg}%")) : all
    val.limit(5)
  end
end
