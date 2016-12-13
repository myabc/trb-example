require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Create, type: :operation do
  let(:admin)           { create(:admin) }
  let(:patient_author)  { create(:patient) }
  let(:clinic)          { create(:clinic, author: patient_author) }

  context 'with invalid params' do
    subject(:operation) { Nurse::Create.run(params)[1] }

    context 'with invalid qualification options params' do
      let(:params) {
        {
          nurse: {
            notes:      'Without patient skills, _no chance!_',
            notes_html: '<p>Without patient skills, <em>no chance!</em></p>',
            current:    true,
            qualifications: [
              { position: 1 },
              { position: 2 },
              { name: 'Pearson BTEC Level 3' }
            ]
          },
          clinic_id:    clinic.id,
          current_user: patient_author
        }.with_indifferent_access
      }

      it 'does not create the nurse' do
        expect(operation.model).not_to be_persisted
        expect(operation.contract.errors.messages)
          .to include("qualifications.name": ['must be filled'])
      end
    end
  end

  context 'with valid params' do
    let(:other_author) { create(:patient) }
    let(:current_user) { patient_author }

    subject(:operation) { Nurse::Create.call(params) }

    let(:params) {
      {
        nurse: {
          notes:      'Without patient skills, _no chance!_',
          notes_html: '<p>Without patient skills, <em>no chance!</em></p>',
          qualifications: [
            { name: 'Advanced Highers' },
            { name: 'A Levels' },
            { name: 'Pearson BTEC Level 3' }
          ],
          status:        'current'
        },
        clinic_id:    clinic.id,
        current_user: current_user
      }.with_indifferent_access
    }

    context 'as a patient' do
      it 'creates the nurse' do
        expect(operation.model).to be_persisted
      end

      it 'assigns current status' do
        expect(operation.model).to be_current
      end
    end

    context 'as an admin' do
      let(:current_user) { admin }

      it 'creates the nurse' do
        expect(operation.model).to be_persisted
      end

      it 'assigns current status' do
        expect(operation.model).to be_current
      end
    end
  end
end
