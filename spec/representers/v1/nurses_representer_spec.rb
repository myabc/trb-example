require 'rails_helper'

RSpec.describe V1::NursesRepresenter do
  let(:collection)  { build_list(:nurse, 2) }
  let(:representer) { V1::NursesRepresenter.new(collection) }
  subject(:output)  { representer.to_json }

  it { is_expected.to have_json_path('nurses') }
  it { is_expected.to have_json_type(Array).at_path('nurses') }
  it { is_expected.to have_json_size(2).at_path('nurses') }

  it { is_expected.to have_json_path('nurses/1/id') }
end
