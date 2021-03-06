module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    # include Elasticsearch::Model::Callbacks

    settings analysis: {
      tokenizer: {
        zhishi_edge_ngram_tokenizer: {
            type: :edgeNGram,
            min_gram: 3,
            max_gram: 20,
            token_chars: [ :letter, :digit ],
        }
      },
      analyzer: {
        zhishi_edge_ngram_analyzer: {
          tokenizer: :zhishi_edge_ngram_tokenizer
        },
      }
    }

    after_touch :index_document_with_elastic_job
    after_save :index_document_with_elastic_job
    after_destroy :delete_document_from_elastic_with_job


    def self.custom_index_name
      [Rails.application.class.parent_name.downcase, Rails.env, model_name.collection.delete('-')].join('_')
    end

    index_name custom_index_name
  end

    def index_document_with_elastic_job
      unless condition_for_reindexing?
        ElasticSearchSchedulerWorker.perform_in(5.seconds, :index, model_name.name, self.id)
      end
    end

    def delete_document_from_elastic_with_job
      ElasticSearchSchedulerWorker.perform_in(5.seconds, :delete, model_name.name, self.id)
    end

    def content_that_should_not_be_indexed
      []
    end

    def condition_for_reindexing?
     (content_that_should_not_be_indexed & self.changed) == self.changed
   end
end
