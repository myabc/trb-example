require 'rails_helper'

RSpec.describe V1::WardRepresenter do
  let(:ward) { build(:ward) }
  let(:department) { build(:department) }
  let(:user)          { nil }
  let(:representer)   { V1::WardRepresenter.new(ward) }
  let(:user_options)  { { current_user: user } }
  subject(:output)    { representer.to_json(user_options: user_options) }

  it { is_expected.to have_json_path('ward/id') }
  it { is_expected.to have_json_path('ward/creator_id') }
  it { is_expected.to have_json_path('ward/created_at') }
  it { is_expected.to have_json_path('ward/updated_at') }
  it { is_expected.to have_json_path('ward/department_id') }
  it { is_expected.to have_json_path('ward/name') }
  it { is_expected.to have_json_path('ward/description') }
  it { is_expected.to have_json_path('ward/category') }
  it { is_expected.to have_json_path('ward/emergency') }
  it { is_expected.to have_json_path('ward/up_votes_count') }

  context 'with an anonymous file' do
    before do
      ward.emergency = true
    end

    it 'does not return the user' do
      is_expected.not_to have_json_path('ward/creator/id')
    end
  end

  context 'write-only properties' do
    let(:parsed) {
      V1::WardRepresenter
        .new(OpenStruct.new)
        .from_json(%( { "ward": {"url":"charite.de"} } ))
    }

    it 'parses url' do
      expect(parsed.url).to eql('charite.de')
    end
  end
end
