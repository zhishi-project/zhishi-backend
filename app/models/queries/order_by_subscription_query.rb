module Queries
  class OrderBySubscriptionQuery
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      Question.with_votes.with_users.joins(join_associations).order(case_statement, sort_by_date_created, sort_by_votes_sum, sort_by_views)
    end

    private
      def sort_by_votes_sum
        "SUM(votes.value) DESC"
      end

      def sort_by_views
        "questions.views DESC"
      end

      def sort_by_date_created
        "questions.created_at DESC"
      end

      def case_handler
        Arel::Nodes::Case.new
      end

      def case_statement
        "CASE WHEN #{user_subscriptions.to_sql} THEN 0 ELSE 2 END"
        # NOTE below method call should be commented out if/when we switch to Rails 5
        # case_handler.when(user_subscriptions).then(0).else(2)
      end

      def user_subscriptions
        tag_table[:id].in(user_tag_association).or(tag_table[:representative_id].in(user_tag_association))
      end

      def user_model
        user.model_name.to_s
      end

      def user_id
        user.id
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

      def resource_tag_to_user_assocation
        resource_tag_table[:taggable_type].eq(user_model).and(resource_tag_table[:taggable_id].eq(user_id))
      end

      def user_tag_association
        tag_table.project(tag_table[:id]).
        outer_join(resource_tag_table).
        on(tag_table[:id].eq(resource_tag_table[:tag_id])).
        where(resource_tag_to_user_assocation)
      end

      def join_associations
        question_table.outer_join(resource_tag_table).on(resource_tag_table[:taggable_id].eq(question_table[:id]).and(resource_tag_table[:taggable_type].eq('Question'))).
        outer_join(tag_table).on(tag_table[:id].eq(resource_tag_table[:tag_id])).join_sources
      end
  end
end
