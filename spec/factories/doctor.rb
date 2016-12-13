FactoryGirl.define do
  factory :doctor do
    clinic

    association :author, factory: :patient
  end
end
