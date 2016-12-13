FactoryGirl.define do
  factory :qualification do
    association :nurse, factory: :nurse
    name 'Qualified'
  end
end
