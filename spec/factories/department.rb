FactoryGirl.define do
  factory :department do
    hospital
    title { Faker::Name.name }

    association :creator, factory: :patient
  end
end
