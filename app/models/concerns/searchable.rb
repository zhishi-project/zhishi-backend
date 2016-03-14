module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    after_touch :index_document_with_elastic_job
    after_save :index_document_with_elastic_job
    after_destroy :delete_document_from_elastic_with_job

    def self.custom_index_name
      [Rails.application.class.parent_name.downcase, Rails.env, model_name.collection.gsub('-', '')].join('_')
    end
    
    index_name custom_index_name
  end

    def index_document_with_elastic_job
      unless (content_that_should_not_be_indexed | self.changed) == self.changed
        ElasticSearchSchedulerWorker.perform_async(:index, model_name.name, self.id)
      end
    end

    def delete_document_from_elastic_with_job
      ElasticSearchSchedulerWorker.perform_async(:delete, model_name.name, self.id)
    end

    def content_that_should_not_be_indexed
      []
    end
end
