require 'rails_helper'

RSpec.describe V1::DoctorRepresenter do
  let(:representer) { V1::DoctorRepresenter.new(doctor) }

  context 'generation' do
    let(:doctor) { build(:doctor) }
    subject(:output) { representer.to_json }

    it { is_expected.to have_json_path('doctor/id') }
    it { is_expected.to have_json_path('doctor/author_id') }

    it { is_expected.to have_json_path('doctor/clinic_id') }
    it { is_expected.to have_json_path('doctor/status') }
    it { is_expected.to have_json_path('doctor/upvotes_count') }
    it { is_expected.to have_json_path('doctor/downvotes_count') }
    it { is_expected.to have_json_path('doctor/created_at') }
    it { is_expected.to have_json_path('doctor/updated_at') }

    it { is_expected.to have_json_path('doctor/biography') }
    it { is_expected.to have_json_path('doctor/notes') }
    it { is_expected.to have_json_path('doctor/biography_html') }
    it { is_expected.to have_json_path('doctor/notes_html') }
  end

  context 'parsing' do
    let(:json) {
      %(
        {
          "doctor": {
            "author_id":          "68",
            "current":          true,
            "biography":      "Hard to fathom a better doctor",
            "biography_html": "<p>Hard to fathom a better doctor</p>",
            "notes":       "Needs better communications.",
            "notes_html":  "<p>Needs better communications.</p>"
          }
        }
      )
    }
    let(:doctor) { Doctor::Contract::Create.new(Doctor.new) }
    let(:contract)  { representer.from_json(json) }
    subject(:model) { contract.model }

    before do
      contract.sync
    end

    it 'sets writeable attributes' do
      expect(model.biography).to eq 'Hard to fathom a better doctor'
      expect(model.notes_html)
        .to eq '<p>Needs better communications.</p>'
      expect(model.current?).to be true
    end

    it 'does not set non-writeable attributes' do
      expect(model.author_id).to be_nil
    end
  end
end
