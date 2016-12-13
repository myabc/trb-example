require 'rails_helper'

RSpec.describe V1::UserRepresenter do
  let(:user)          { build(:patient) }
  let(:representer)   { V1::UserRepresenter.new(user) }
  subject(:output)    { representer.to_json }

  it { is_expected.to have_json_path('user/id') }
  it { is_expected.to have_json_path('user/first_name') }
  it { is_expected.to have_json_path('user/last_name') }
  it { is_expected.to have_json_path('user/nickname') }
  it { is_expected.to have_json_path('user/hospital_id') }
  it { is_expected.to have_json_path('user/admin') }
  it { is_expected.to have_json_path('user/weight') }
  it { is_expected.to have_json_path('user/updated_at') }

  it { is_expected.to have_json_path('user/created_at') }
  it { is_expected.to have_json_path('user/email') }
  it { is_expected.to have_json_path('user/locale') }
end
