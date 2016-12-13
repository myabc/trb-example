FactoryGirl.define do
  factory :vote do
    association :votable, factory: :ward
    association :user, factory: :patient
    direction 'up'
  end
end
