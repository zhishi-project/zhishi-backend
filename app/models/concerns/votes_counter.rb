module VotesCounter
  extend ActiveSupport::Concern
  included do

    scope :with_votes, VotesQuery.new(self)

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


  class VotesQuery
    attr_reader :relation

    def initialize(relation)
      @relation = relation
    end

    def votes_table
      Vote.arel_table
    end

    def resource_table
      relation.arel_table
    end

    def total_votes
      votes_table[:value].sum.as("total_votes")
    end

    def resource_data
      resource_table[Arel.star]
    end

    def join_associations
      resource_table.outer_join(votes_table).on(resource_table[:id].eq(votes_table[:voteable_id]).
      and(votes_table[:voteable_type].eq(relation.to_s))).join_sources
    end

    def call
      relation.joins(join_associations).select(resource_data, total_votes).group("#{relation.table_name}.id")
    end
  end
end
