module Notifications
  class NewVoteSerializer < VoteSerializer
    attributes :type
    has_one :subscribers

    private
      def root
        :notification
      end

      def type
        'new.vote'
      end
  end
end
