FactoryGirl.define do
  factory :patient, class: User do
    email { Faker::Internet.email }
  end

  factory :admin, class: User do
    email { Faker::Internet.email }
    admin true
  end
end
