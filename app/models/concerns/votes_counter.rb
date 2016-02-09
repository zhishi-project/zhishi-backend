module VotesCounter
  extend ActiveSupport::Concern

  included do
      scope :with_votes, -> {
        joins("LEFT JOIN votes ON votes.voteable_id = #{table_name}.id AND votes.voteable_type = '#{to_s}'").select("#{table_name}.*, SUM(votes.value) AS total_votes").group("#{table_name}.id")
      }

      scope :top, ->(needed=10) {
        with_votes.order('total_votes DESC, created_at DESC').limit(needed)
      }

      scope :by_date, -> {
        with_votes.order('created_at DESC')
      }
  end

  def votes_count
    try(:total_votes) || votes.sum(:value)
  end

end
