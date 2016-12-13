FactoryGirl.define do
  factory :thread, class: Commenting::Thread do
    association :subject, factory: :department
  end
end
