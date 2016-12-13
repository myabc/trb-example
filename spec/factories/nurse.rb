FactoryGirl.define do
  factory :nurse do
    clinic

    association :author, factory: :patient
  end
end
