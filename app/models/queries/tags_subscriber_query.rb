module Queries
  class TagsSubscriberQuery
    # NOTE this interface could have been closely coupled with the question,
    # but then it would have been difficult if there were other resources that
    # users could subscribe to.

    attr_reader :relation, :resource

    def initialize(resource)
      @relation = User.all
      @resource = resource
    end

    def call
      relation.
      joins(:tags).
      where(user_subscriptions).
      distinct

    end

    private

      def resource_tag_table
        ResourceTag.arel_table
      end

      def tag_table
        Tag.arel_table
      end

      def user_table
        User.arel_table
      end

      def resource_id
        resource.id
      end

      def resource_name
        resource.model_name.to_s
      end

      def resource_table
        resource.class.arel_table
      end

      def user_subscriptions
        tag_table[:id].in(relation_tag_association).or(tag_table[:representative_id].in(relation_tag_association))
      end

      def relation_tag_association
        tag_table.project(tag_table[:id]).
        join(resource_tag_table).
        on(tag_table[:id].eq(resource_tag_table[:tag_id])).
        where(resource_tag_to_user_assocation)
      end

      def resource_tag_to_user_assocation
        resource_tag_table[:taggable_type].eq(resource_name).and(resource_tag_table[:taggable_id].eq(resource_id))
      end
  end
end
