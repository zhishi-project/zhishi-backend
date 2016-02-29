FactoryGirl.define do
  factory :resource_tag do
    tag
    factory :question_resource_tag do
      association :taggable, factory: :question
    end

    factory :user_resource_tag do
      association :taggable, factory: :user
    end
  end
end
