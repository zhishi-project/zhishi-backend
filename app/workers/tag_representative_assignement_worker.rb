class TagRepresentativeAssignementWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :tags, backtrace: true

  Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil

  def perform(tag_id, tag_name)
    search_resolution = Tag.resolution_for(tag_name)
    representative = Tag.search(search_resolution).first
    Tag.find(tag_id).update(representative_id: representative.id) if representative
  end

end
