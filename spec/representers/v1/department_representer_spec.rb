require 'rails_helper'

RSpec.describe V1::DepartmentRepresenter do
  let(:representer) { V1::DepartmentRepresenter.new(department) }

  context 'generation' do
    let(:department) { build(:department) }
    let(:user)          { nil }
    let(:user_options)  { { current_user: user } }
    subject(:output)    { representer.to_json(user_options: user_options) }

    it { is_expected.to have_json_path('department/id') }
    it { is_expected.to have_json_path('department/self_url') }
    it { is_expected.to have_json_path('department/slug') }

    it { is_expected.to have_json_path('department/title') }
    it { is_expected.to have_json_path('department/org_code') }
    it { is_expected.to have_json_path('department/director_name') }

    it { is_expected.to have_json_path('department/creator_id') }

    it { is_expected.to have_json_path('department/hospital_id') }
    it { is_expected.to have_json_path('department/contact_phones') }

    context 'with nil current_user' do
    end

    context 'with current_user' do
      let(:user) { build(:patient) }
    end

    context 'with explicit nil user_options' do
      let(:user_options) { nil }
    end

    it { is_expected.to have_json_path('department/published') }

    context 'embedding' do
      it 'includes embedded resources' do
        is_expected.to have_json_path('department/clinics')
      end
    end

    context 'optional embedding' do
      let(:user)         { build(:patient) }
      let(:user_options) { { current_user: user, includes: includes } }

      context 'with no includes specified' do
        let(:includes) { %w() }

        it 'includes specified embedded resources' do
          is_expected.not_to have_json_path('department/doctors')
          is_expected.not_to have_json_path('department/nurses')
        end
      end

      context 'of nurses' do
        let(:includes) { %w(nurses) }

        it 'includes specified embedded resources' do
          is_expected.to have_json_path('department/nurses')
          is_expected.not_to have_json_path('department/doctors')
        end
      end

      context 'of doctors' do
        let(:includes) { %w(doctors) }

        it 'includes specified embedded resources' do
          is_expected.to have_json_path('department/doctors')
          is_expected.not_to have_json_path('department/nurses')
        end
      end
    end
  end

  context 'parsing' do
    let(:json) {
      %(
        {
          "department": {
            "title":            "Next department"
          }
        }
      )
    }
    let(:department) { Department.new }
    subject(:object) { representer.from_json(json) }

    it 'sets writeable attributes' do
      expect(object.title).to eq 'Next department'
    end

    xit 'does not set non-writeable attributes' do
    end
  end
end
