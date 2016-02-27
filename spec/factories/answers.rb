FactoryGirl.define do
  factory :answer do
    content { Faker::Lorem.paragraph }
    user
    question

    factory :answer_with_comments do
      transient do
        comments_count 5
      end

      after(:create) do |answer, evaluator|
        create_list(:comment_on_answer, evaluator.comments_count, comment_on: answer)
      end
    end

    factory :answer_with_votes do
      transient do
        votes_count 5
      end

      after(:create) do |answer, evaluator|
        create_list(:vote_on_answer, evaluator.votes_count, voteable: answer)
      end
    end
  end
end
