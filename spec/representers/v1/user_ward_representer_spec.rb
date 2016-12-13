require 'rails_helper'

RSpec.describe V1::UserWardRepresenter do
  let(:ward) { build(:ward) }
  let(:department) { build(:department) }
  let(:user)          { nil }
  let(:representer)   { V1::UserWardRepresenter.new(ward) }
  let(:user_options)  { { current_user: user } }
  subject(:output)    { representer.to_json(user_options: user_options) }

  it { is_expected.to have_json_path('ward/id') }
  it { is_expected.to have_json_path('ward/created_at') }
  it { is_expected.to have_json_path('ward/updated_at') }
  it { is_expected.to have_json_path('ward/department_id') }
  it { is_expected.to have_json_path('ward/name') }
  it { is_expected.to have_json_path('ward/category') }
  it { is_expected.to have_json_path('ward/emergency') }
  it { is_expected.to have_json_path('ward/up_votes_count') }

  it { is_expected.not_to have_json_path('ward/creator') }
end
