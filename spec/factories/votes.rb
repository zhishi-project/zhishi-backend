FactoryGirl.define do
  factory :vote do
    value Faker::Number.between(-1, 1)
    user

    factory :vote_on_question do
      association :voteable, factory: :question
    end

    factory :vote_on_answer do
      association :voteable, factory: :answer
    end

    factory :vote_on_comment do
      association :voteable, factory: :comment
    end
  end
end
