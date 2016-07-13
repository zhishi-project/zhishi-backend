module AcceptAnswerHelper
  extend ActiveSupport::Concern
  
  included do
    after_update :notify_user_of_accepted_answer, if: :accepted_changed?
  end

  def notify_user_of_accepted_answer
    AcceptedAnswerWorker.perform_in(5.seconds, id)
  end

  def notify_user_of_acceptance
    if accepted?
      vote = Vote.new(voteable: self, value: 20)
      vote.distribute_to_notification_queue
    end
  end
end
