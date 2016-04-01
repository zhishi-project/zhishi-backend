namespace :zhishi do
  namespace :es do
    desc "Reindex all params[model_name] on ElasticSearch. Usage rake zhishi:es:reindex[question]"
    task :reindex, [:model_name] => :environment do |_, arg|
      model_name = arg[:model_name].singularize.camelize.constantize
      model_name.import force: true
    end

    desc "Creates a new version of the model_name on ES. Usage rake zhishi:es:revise[question]"
    task :revise, [:model_name] => :environment do |_, arg|
      model_name = arg[:model_name].singularize.camelize.constantize
      model_name.import
    end
  end
end
