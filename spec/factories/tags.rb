FactoryGirl.define do
  factory :tag do
    name { Faker::Book.genre }

    factory :tag_with_representative do
      association :representative, factory: :tag
    end
  end
end
