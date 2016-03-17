module VotesCounter
  extend ActiveSupport::Concern
  included do

    scope :with_votes, Queries::VotesQuery.new(self)

    scope :ordered_by_top, -> {
      with_votes.order('total_votes DESC, created_at DESC')
    }

    scope :top, ->(needed=10) {
      ordered_by_top.paginate(per_page: needed, page: 1)
    }

    scope :by_date, -> {
      with_votes.order('created_at DESC')
    }
  end

  def votes_count
    if respond_to? :total_votes
      total_votes.to_i
    else
      votes_alternative
    end
  end

  def votes_alternative
    votes.reduce(0) do |sum , vote|
      sum + vote.value
    end
  end
end
