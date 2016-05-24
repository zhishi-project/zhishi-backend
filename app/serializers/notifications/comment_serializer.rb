module Notifications
  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :content, :url, :type
    has_one :user
    has_one :parent

    private
      def url
        resource_name = object.comment_on.model_name.route_key
        resource_id = object.comment_on_id
        comment_url(object, resource_name: resource_name, resource_id: resource_id)
      end

      def type
        'Comment'
      end

      def parent
        object.comment_on
      end
  end
end
