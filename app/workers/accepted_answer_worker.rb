class AcceptedAnswerWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :notifications, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

  def perform(object_id)
    answer = Answer.find(object_id)
    answer.notify_user_of_acceptance
  end
end
