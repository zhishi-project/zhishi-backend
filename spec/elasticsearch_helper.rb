require 'rake'
# require 'elasticsearch/extensions/test/cluster/tasks'

RSpec.configure do |config|
  # config.before(:suite) do
  #   Question.import force: true
  #   Tag.import force: true
  #   # Rake::Task['zhishi:es:reindex[question]'].invoke
  # end

  # config.before :each, elasticsearch: true do
  #   Elasticsearch::Extensions::Test::Cluster.start(port: 9200, path_logs: 'log/elasticsearch') unless Elasticsearch::Extensions::Test::Cluster.running?
  # end

  # config.after :suite do
  #   Elasticsearch::Extensions::Test::Cluster.stop(port: 9200) if Elasticsearch::Extensions::Test::Cluster.running?
  # end
end
