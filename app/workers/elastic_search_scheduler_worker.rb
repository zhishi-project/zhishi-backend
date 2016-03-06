class ElasticSearchSchedulerWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :elasticsearch, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

  def perform(action, *args)
    object = args[0].capitalize.constantize

    logger.debug [action, "#{object} with ID of #{args[1]}"]

    case action.to_s
    when /index/
      object.find(args[1]).__elasticsearch__.index_document
    when /delete/
      Elasticsearch::Model.client.delete index: object.custom_index_name, type: object.model_name.element, id: args[1]
    end
  end
end
