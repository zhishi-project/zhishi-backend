FactoryGirl.define do
  factory :question do
    title { Faker::StarWars.quote }
    content { Faker::Hipster.paragraph }
    views { rand(5) }
    user

    factory :question_with_tag do
      transient do
        tags_count 5
      end
      after(:create) do |question, evaluator|
        create_list(:tag, evaluator.tags_count, taggable: question)
      end
    end

    factory :question_with_votes do
      transient do
        votes_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:vote_on_question, evaluator.votes_count, voteable: question)
      end
    end

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

    factory :question_with_comments do
      transient do
        comments_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:comment_on_question, evaluator.comments_count, comment_on: question)
      end
    end
  end
end
