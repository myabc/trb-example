FactoryGirl.define do
  factory :hospital do
    name            { Faker::Name.name }
    acronym         'GT'
    url             'http://guysandstthomas.nhs.uk'
    street          'Great Maze Pond'
    street_number   '1'
    postal_code     'SE1 9RT'
  end
end
