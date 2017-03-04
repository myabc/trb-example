require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Update, type: :operation do
  include_context 'with an existing former nurse'

  context 'with invalid nested params' do
    subject(:operation) { Nurse::Update.call(params, 'current_user' => patient_author) }

    let(:params) {
      {
        nurse: {
          qualifications: [
            {
              id:         nurse.qualifications[1].id,
              name:       'A Levels',
              _destroy:   true
            },
            {
              id:         nurse.qualifications[2].id,
              name:       'Pearson BTEC Level 3',
              _destroy:   true
            }
          ]
        },
        id: nurse.id
      }.with_indifferent_access
    }

    it 'does not update the nurse' do
      expect(operation['result.contract.default'].errors.messages)
        .to include(qualifications: [/Needs at least two qualifications/])
    end
  end

  context 'with valid params' do
    let(:current_user)  { patient_author }

    subject(:operation) { Nurse::Update.call(params, 'current_user' => current_user) }

    let(:params) {
      {
        nurse: {
          notes:      'Without valid qualification, _no chance!_',
          notes_html: '<p>Without valid qualification, <em>no chance!</em></p>',
          qualifications: [
            {
              id:         nurse.qualifications[1].id,
              name:       'OCR Cambridge Technicals'
            },
            {
              id:         nurse.qualifications[2].id,
              name:       'Pearson BTEC Level 3',
              _destroy:   true
            },
            {
              name:      'Scottish Highers'
            }
          ]
        },
        id: nurse.id
      }.with_indifferent_access
    }

    it 'updates the nurse' do
      expect(operation['model'].notes_html)
        .to eq '<p>Without valid qualification, <em>no chance!</em></p>'
    end

    it 'updates nested qualifications' do
      qualifications = operation['model'].qualifications

      expect(qualifications.size).to eq 3
      expect(qualifications.map(&:name))
        .not_to include 'Pearson BTEC Level 3'
      expect(qualifications.reload.map(&:name))
        .to contain_exactly 'Advanced Highers', 'OCR Cambridge Technicals', 'Scottish Highers'
    end
  end

  context 'with valid params' do
    let(:other_clinic)  { create(:clinic, author: patient_author) }
    let(:other_author)  { create(:patient) }
    let(:current_user)  { patient_author }

    subject(:operation) { Nurse::Update.call(params, 'current_user' => current_user) }

    let(:params) {
      {
        nurse: {
          notes:      'Without valid qualification, _no chance!_',
          notes_html: '<p>Without valid qualification, <em>no chance!</em></p>',
          status:     'current',
          clinic_id:  other_clinic.id,
          author_id:  other_author.id
        },
        id: nurse.id
      }.with_indifferent_access
    }

    context 'as a patient' do
      it 'updates the nurse' do
        expect(operation['model'].notes_html)
          .to eq '<p>Without valid qualification, <em>no chance!</em></p>'
      end

      it "updates the nurse's status" do
        expect(operation['model']).to be_current
      end

      it "does not update the nurse's author" do
        expect(operation['model'].author).to eq patient_author
      end

      it "does not update the nurse's clinic" do
        expect(operation['model'].clinic).to eq clinic
      end
    end

    context 'as an admin' do
      let(:current_user) { create(:admin) }

      it 'updates the nurse' do
        expect(operation['model'].notes_html)
          .to eq '<p>Without valid qualification, <em>no chance!</em></p>'
      end

      it "updates the nurse's status" do
        expect(operation['model']).to be_current
      end

      it "updates the nurse's author" do
        expect(operation['model'].author).to eq other_author
      end

      it "updates the nurse's clinic" do
        expect(operation['model'].clinic).to eq other_clinic
      end
    end
  end
end
