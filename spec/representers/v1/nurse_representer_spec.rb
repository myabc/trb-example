require 'rails_helper'

RSpec.describe V1::NurseRepresenter do
  let(:representer) { V1::NurseRepresenter.new(nurse) }

  context 'generation' do
    let(:nurse) { build(:nurse, qualifications: build_list(:qualification, 2)) }
    subject(:output) { representer.to_json }

    it { is_expected.to have_json_path('nurse/id') }
    it { is_expected.to have_json_path('nurse/author_id') }

    it { is_expected.to have_json_path('nurse/clinic_id') }
    it { is_expected.to have_json_path('nurse/status') }
    it { is_expected.to have_json_path('nurse/upvotes_count') }
    it { is_expected.to have_json_path('nurse/downvotes_count') }
    it { is_expected.to have_json_path('nurse/created_at') }
    it { is_expected.to have_json_path('nurse/updated_at') }

    it { is_expected.to have_json_path('nurse/notes') }
    it { is_expected.to have_json_path('nurse/notes_html') }
    it { is_expected.to have_json_path('nurse/updated_at') }

    describe 'qualifications' do
      it {
        is_expected.to have_json_type(Array)
          .at_path('nurse/qualifications')
      }
      xit do is_expected.to have_json_path('nurse/qualifications/0/id') end
      it { is_expected.to have_json_path('nurse/qualifications/0/position') }
      it { is_expected.to have_json_path('nurse/qualifications/0/name') }
    end
  end

  context 'parsing' do
    let(:json) {
      %(
        {
          "nurse": {
            "author_id":  "67",
            "notes":      "Needs better communications.",
            "notes_html": "<p>Needs better communications.</p>"
          }
        }
      )
    }
    let(:nurse) { Nurse::Contract::Create.new(Nurse.new) }
    let(:contract)  { representer.from_json(json) }
    subject(:model) { contract.model }

    before do
      contract.sync
    end

    it 'sets writeable attributes' do
      expect(model.notes).to eq 'Needs better communications.'
      expect(model.notes_html)
        .to eq '<p>Needs better communications.</p>'
    end

    it 'does not set non-writeable attributes' do
      expect(model.author_id).to be_nil
    end
  end
end
