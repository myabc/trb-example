require 'rails_helper'

RSpec.describe V1::WardsRepresenter do
  let(:collection)    { build_list(:ward, 2) }
  let(:representer)   { V1::WardsRepresenter.new(collection) }
  subject(:output)    { representer.to_json }

  it { is_expected.to have_json_path('wards') }
  it { is_expected.to have_json_type(Array).at_path('wards') }
  it { is_expected.to have_json_size(2).at_path('wards') }

  it { is_expected.to have_json_path('wards/1/id') }
end
