FactoryGirl.define do
  factory :patient, class: User do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end

  factory :admin, class: User do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admin true
  end
end
