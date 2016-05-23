module Queries
  class UserQuestionsQuery
    attr_reader :user, :relation

    def initialize(user, relation = Question.eager_load_basic_association)
      @user = user
      @relation = relation
    end

    def call
      relation.joins(:tags).where(user_subscriptions).distinct
    end

    private
      def user_subscriptions
        tag_table[:id].in(user_tag_association).or(tag_table[:representative_id].in(user_tag_association))
      end

      def user_model
        user.model_name.to_s
      end

      def user_id
        user.id
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
        join(resource_tag_table).
        on(tag_table[:id].eq(resource_tag_table[:tag_id])).
        where(resource_tag_to_user_assocation)
      end
  end
end
