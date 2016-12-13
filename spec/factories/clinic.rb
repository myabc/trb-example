FactoryGirl.define do
  factory :clinic do
    department
    title { Faker::Name.name }

    association :author, factory: :patient
  end
end
