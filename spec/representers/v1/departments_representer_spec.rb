require 'rails_helper'

RSpec.describe V1::DepartmentsRepresenter do
  let(:collection)  { build_list(:department, 2) }
  let(:representer) { V1::DepartmentsRepresenter.new(collection) }
  subject(:output)  { representer.to_json }

  it { is_expected.to have_json_path('departments') }
  it { is_expected.to have_json_type(Array).at_path('departments') }
  it { is_expected.to have_json_size(2).at_path('departments') }

  it { is_expected.to have_json_path('departments/1/id') }

  context 'embedding' do
    it 'does not include embedded resources' do
      is_expected.not_to have_json_path('departments/1/clinics')
    end
  end
end
