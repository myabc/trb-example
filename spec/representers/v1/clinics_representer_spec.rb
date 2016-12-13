require 'rails_helper'

RSpec.describe V1::ClinicsRepresenter do
  let(:collection)  { build_list(:clinic, 2) }
  let(:representer) { V1::ClinicsRepresenter.new(collection) }
  subject(:output)  { representer.to_json }

  it { is_expected.to have_json_path('clinics') }
  it { is_expected.to have_json_type(Array).at_path('clinics') }
  it { is_expected.to have_json_size(2).at_path('clinics') }

  it { is_expected.to have_json_path('clinics/1/id') }

  context 'embedding' do
    it 'does not include embedded resources' do
      is_expected.not_to have_json_path('clinics/1/doctors')
      is_expected.not_to have_json_path('clinics/1/nurses')
    end
  end
end
