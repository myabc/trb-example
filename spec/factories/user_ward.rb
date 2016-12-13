FactoryGirl.define do
  factory :user_ward do
    ward
    association :user, factory: :patient
  end
end
