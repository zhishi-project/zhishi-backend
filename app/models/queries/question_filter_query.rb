module Queries
  class QuestionFilterQuery
    attr_reader :relation, :tag_ids

    def initialize(relation: Question, tag_ids: [])
      @relation = relation
      @tag_ids = tag_ids
    end

    def call
      relation.with_basic_association.joins(join_associations).where(association_query)
    end

    private
      def join_associations
        question_table.outer_join(resource_tag_table).on(resource_tag_table[:taggable_id].eq(question_table[:id]).and(resource_tag_table[:taggable_type].eq('Question'))).
        outer_join(tag_table).on(tag_table[:id].eq(resource_tag_table[:tag_id])).outer_join(representative_table).on(tag_table[:representative_id].eq(representative_table[:id])).join_sources
      end

      def question_table
        Question.arel_table
      end

      def tag_table
        Tag.arel_table
      end

      def resource_tag_table
        ResourceTag.arel_table
      end

      def representative_table
        tag_table.alias('representative')
      end

      def association_query
        tags_that_matches_exactly.or(tags_that_have_common_representative).or(with_the_representative_tags)
      end

      def tags_that_matches_exactly
        tag_table[:id].in(tag_ids)
      end

      def tags_that_have_common_representative
        representative_table[:id].in(tag_ids)
      end

      def with_the_representative_tags
        tag_table[:id].in(tag_table.project(tag_table[:representative_id]).where(tag_table[:id].in(tag_ids)))
      end
  end
end
