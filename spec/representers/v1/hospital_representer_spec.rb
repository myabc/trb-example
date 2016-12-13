require 'rails_helper'

RSpec.describe V1::HospitalRepresenter do
  let(:hospital) { build(:hospital) }
  let(:representer) { V1::HospitalRepresenter.new(hospital) }
  subject(:output) { representer.to_json }

  it { is_expected.to have_json_path('hospital/id') }
  it { is_expected.to have_json_path('hospital/self_url') }
  it { is_expected.to have_json_path('hospital/slug') }

  it { is_expected.to have_json_path('hospital/name') }
  it { is_expected.to have_json_path('hospital/acronym') }
  it { is_expected.to have_json_path('hospital/country_code') }
  it { is_expected.to have_json_path('hospital/city') }
  it { is_expected.to have_json_path('hospital/updated_at') }

  it { is_expected.to have_json_path('hospital/url') }
  it { is_expected.to have_json_path('hospital/city') }
  it { is_expected.to have_json_path('hospital/postal_code') }
  it { is_expected.to have_json_path('hospital/street') }
  it { is_expected.to have_json_path('hospital/street_number') }
end
