FactoryGirl.define do
  factory :token do
    user

    factory :active_token do
      status :active
    end

    factory :inactive_token do
      status :inactive
    end
  end
end
