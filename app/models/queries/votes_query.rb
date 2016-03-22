module Queries
  class VotesQuery
    attr_reader :relation

    def initialize(relation)
      @relation = relation
    end

    def call
      relation.joins(join_associations).select(resource_data, total_votes).group("#{relation.table_name}.id")
    end

    private
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
  end
end
