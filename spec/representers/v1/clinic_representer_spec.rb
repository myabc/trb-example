require 'rails_helper'

RSpec.describe V1::ClinicRepresenter do
  let(:representer) { V1::ClinicRepresenter.new(clinic) }

  context 'generation' do
    let(:clinic)       { build(:clinic) }
    let(:user)          { nil }
    let(:user_options)  { { current_user: user } }
    subject(:output)    { representer.to_json(user_options: user_options) }

    it { is_expected.to have_json_path('clinic/id') }

    it { is_expected.to have_json_path('clinic/title') }
    it { is_expected.to have_json_path('clinic/updated_at') }
    it { is_expected.to have_json_path('clinic/department_id') }
    it { is_expected.to have_json_path('clinic/author_id') }

    context 'with nil current_user' do
    end

    context 'with current_user' do
      let(:user) { build(:patient) }
    end

    context 'with explicit nil user_options' do
      let(:user_options) { nil }
    end

    context 'embedding' do
      it 'includes embedded resources' do
        is_expected.to have_json_path('clinic/doctors')
        is_expected.to have_json_path('clinic/nurses')
      end
    end
  end

  context 'parsing' do
    let(:json) {
      %(
        {
          "clinic": {
            "title": "Next clinic"
          }
        }
      )
    }
    let(:clinic) { Clinic.new }
    subject(:object) { representer.from_json(json) }

    it 'sets writeable attributes' do
      expect(object.title).to eq 'Next clinic'
    end

    xit 'does not set non-writeable attributes' do
    end
  end
end
