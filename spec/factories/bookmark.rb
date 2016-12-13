FactoryGirl.define do
  factory :bookmark do
    association :bookmarkable, factory: :ward
    association :user, factory: :patient
  end
end
