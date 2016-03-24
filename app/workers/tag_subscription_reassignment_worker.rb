class TagSubscriptionReassignmentWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :tags, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

  def perform(id)
    Tag.find(id).update_tag_subscriptions
  end
end
