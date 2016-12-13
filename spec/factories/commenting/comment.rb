FactoryGirl.define do
  factory :comment, class: Commenting::Comment do
    thread
    association :author, factory: :patient
    message 'Clearly this information is problematic.'

    trait :with_feedback do
      feedback { FactoryGirl.create :feedback, creator: author }
    end

    trait :with_replies do
      transient do
        replies_count { Random.rand(3...9) }
      end

      after(:create) do |comment, evaluator|
        create_list :comment, evaluator.replies_count, reply_to: comment
      end
    end
  end
end
