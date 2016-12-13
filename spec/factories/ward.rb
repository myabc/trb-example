FactoryGirl.define do
  factory :ward do
    department
    name { Faker::Name.name }

    association :creator, factory: :patient
  end
end
