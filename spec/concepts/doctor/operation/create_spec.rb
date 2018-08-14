require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Create, type: :operation do
  let(:admin) { create(:admin) }
  let(:patient_author) { create(:patient) }
  let(:clinic) { create(:clinic, author: patient_author) }

  context 'with invalid params' do
    subject(:operation) { Doctor::Create.call(params, 'current_user' => patient_author) }

    let(:params) {
      {
        doctor:       { biography: '' },
        clinic_id:    clinic.id
      }.with_indifferent_access
    }

    it 'does not create the doctor' do
      expect(operation['model']).not_to be_persisted
      expect(operation['result.contract.default'].errors.messages)
        .to eq(notes_html: ['must be filled'], biography_html: ['must be filled'])
    end
  end

  context 'with valid params' do
    let(:other_author) { create(:patient) }
    let(:current_user) { patient_author }

    subject(:operation) { Doctor::Create.call(params, 'current_user' => current_user) }

    let(:params) {
      {
        doctor: {
          biography:      'Pizza making begins with good flour.',
          biography_html: '<p>Pizza making begins with good flour.</p>',
          notes:          'A good GP.',
          notes_html:     '<p>A good GP.</p>',
          status:         'current'
        },
        clinic_id:    clinic.id
      }.with_indifferent_access
    }

    context 'as a patient' do
      it 'creates the doctor' do
        expect(operation['model']).to be_persisted
      end

      it 'assigns current status' do
        expect(operation['model']).to be_current
      end
    end

    context 'as an admin' do
      let(:current_user) { admin }

      it 'creates the doctor' do
        expect(operation['model']).to be_persisted
      end

      it 'assigns current status' do
        expect(operation['model']).to be_current
      end
    end
  end
end
