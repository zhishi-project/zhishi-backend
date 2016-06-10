namespace :remap_tags do

  desc "this task remaps and deletes tags. This is a one time task!"
  task execute: :environment do
    map_tags
    rename_and_delete_tags
    implement_new_tag_naming_convention
    puts "Completed!!!"
  end

  def map_tags
    tags = {
            "food" => ["meals"],
            "fellows-lagos" => ["fellows lagos", "lagos"],
            "php" => ["pdo", "laravel", "dbal"],
            "training" => ["cousera", "simulations"],
            "sports" =>["football"],
            "healthcare" => ["kbl", "bupa", "health"],
            "javascript" => ["dom", "superagent"],
            "react" => ["react router"],
            "ruby" => ["rspec", "serializers"],
            "testing" => ["faker", "mock", "stub", "unit-testing"],
            "operations" => ["leave", "leave-request", "annual-leave"],
            "mac" => ["osx"],
            "nairobi-fellows" => ["brown-bag", "kenya"],
            "databases" => ["sql", "database relationships"],
            "api" => ["rest"],
            "css" => ["flexbox"]
            }

    tags.each do |key, value|
      parent_tag = Tag.where(name: key)
      Tag.where(name: value).update_all(representative_id: parent_tag)
    end
    puts "Sucessfuly Mapped Tags!"
  end

  def rename_and_delete_tags
    old_tags = {
                "module" => "ruby",
                "survey" => "fellows",
                "staff" => "operations",
                "queries" => "databases",
                "deployment" => "laravel"
                }

    old_tags.each do |key, value|
        new_tag = Tag.where(name: value)
        ResourceTag.joins(:tag).where(tags: {name: key}).update_all(tag_id: new_tag)
    end

    tags_to_delete = ["computer science", "operation", "forms", "networking", "pdo-connection",
     "paid-courses", "programming", "associations", "facility", "ci", "mixin",
     "discussion", "promotions", "beautiful soup"] + old_tags.keys

    Tag.where(name: "orders").update_all(name: "ny-office")
    Tag.where(name: "history").update_all(name: "andela-history")
    Tag.where(name: "databases").update_all(name: "database")

    Tag.where(name: tags_to_delete).destroy_all

    puts "Sucessfuly Renamed And Deleted Unwanted Tags!!"
  end

  def implement_new_tag_naming_convention
    Tag.find_each do |tag|
      name = tag.name.split(' ').join('-')
      tag.update(name: name)
    end
    puts "Naming convention successfully implemented"
  end
end
