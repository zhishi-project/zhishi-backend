FactoryGirl.define do
  factory :tag do
    name Faker::Book.genre
  end
end
