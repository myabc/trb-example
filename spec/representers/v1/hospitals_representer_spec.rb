require 'rails_helper'

RSpec.describe V1::HospitalsRepresenter do
  let(:collection)  { build_list(:hospital, 2) }
  let(:representer) { V1::HospitalsRepresenter.new(collection) }
  subject(:output)  { representer.to_json }

  it { is_expected.to have_json_path('hospitals') }
  it { is_expected.to have_json_type(Array).at_path('hospitals') }
  it { is_expected.to have_json_size(2).at_path('hospitals') }

  it { is_expected.to have_json_path('hospitals/1/id') }
end
