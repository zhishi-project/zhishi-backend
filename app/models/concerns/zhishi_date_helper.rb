module ZhishiDateHelper
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::DateHelper
  end

  def created_since
    distance_of_time_in_words(created_at, Time.zone.now) + " ago"
  end

  def updated_since
    distance_of_time_in_words(updated_at, Time.zone.now) + " ago"
  end
end
