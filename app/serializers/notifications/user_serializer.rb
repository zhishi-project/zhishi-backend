module Notifications
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :points, :image, :url, :type

    private
      def url
        user_url(object)
      end

      def type
        'User'
      end
  end
end
