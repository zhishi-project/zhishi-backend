FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{Faker::Lorem.word}#{n}@andela.com" }

    factory :user_with_comments_on_question do
      transient do
        comments_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:comment_on_question, evaluator.comments_count, user: user)
      end
    end

    factory :user_with_comments_on_answer do
      transient do
        comments_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:comment_on_answer, evaluator.comments_count, user: user)
      end
    end

    factory :user_with_tags do
      transient do
        tags_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:tag, evaluator.tags_count, subscriber: user)
      end
    end

    factory :user_with_questions do
      transient do
        questions_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user: user)
      end
    end

    factory :user_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:answer, evaluator.answers_count, user: user)
      end
    end

    factory :user_with_votes_on_question do
      transient do
        votes_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:vote_on_question, evaluator.votes_count, user: user)
      end
    end

    factory :user_with_votes_on_answer do
      transient do
        votes_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:vote_on_answer, evaluator.votes_count, user: user)
      end
    end

    factory :user_with_votes_on_comment do
      transient do
        votes_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:vote_on_comment, evaluator.votes_count, user: user)
      end
    end
  end
end
