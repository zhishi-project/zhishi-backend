module Notifications
  class VoteSerializer < ActiveModel::Serializer
    attributes :id, :vote_type, :type
    has_one :user
    has_one :vote_on

    private
      def vote_on
        object.voteable
      end

      def type
        'Vote'
      end
  end
end
