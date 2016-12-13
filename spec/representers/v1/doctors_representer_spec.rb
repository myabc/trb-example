require 'rails_helper'

RSpec.describe V1::DoctorsRepresenter do
  let(:collection)  { build_list(:doctor, 2) }
  let(:representer) { V1::DoctorsRepresenter.new(collection) }
  subject(:output)  { representer.to_json }

  it { is_expected.to have_json_path('doctors') }
  it { is_expected.to have_json_type(Array).at_path('doctors') }
  it { is_expected.to have_json_size(2).at_path('doctors') }

  it { is_expected.to have_json_path('doctors/1/id') }
end
