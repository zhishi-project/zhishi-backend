FactoryGirl.define do
  factory :comment do
    content { Faker::Hacker.say_something_smart }
    user

    factory :comment_on_question do
      association :comment_on, factory: :question
    end

    factory :comment_on_answer do
      association :comment_on, factory: :question
    end

    factory :comment_with_votes do
      transient do
        votes_count 5
      end

      after(:create) do |comment, evaluator|
        create_list(:vote_on_comment, evaluator.votes_count, voteable: comment)
      end
    end
  end
end
