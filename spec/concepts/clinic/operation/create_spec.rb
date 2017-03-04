require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Clinic::Create, type: :operation do
  let(:patient_author) { create(:patient) }
  let(:department) {
    create(:department, title: 'Urology')
  }

  context 'with invalid params' do
    subject(:operation) { Clinic::Create.call(params, 'current_user' => patient_author) }

    context 'when params are missing' do
      let(:params) {
        {
          clinic:         { title: '' },
          department_id:  department.id
        }.with_indifferent_access
      }

      it 'does not create the clinic' do
        expect(operation['model']).not_to be_persisted
        expect(operation['result.contract.default'].errors.messages)
          .to eq(title: ['must be filled', 'size cannot be greater than 50'])
      end
    end
  end

  context 'with valid params' do
    subject(:operation) { Clinic::Create.call(params, 'current_user' => patient_author) }

    let(:params) {
      {
        clinic:         { title: "\nOutpatient Haematology Clinic" },
        department_id:  department.id
      }.with_indifferent_access
    }

    it 'creates the clinic' do
      expect(operation['model']).to be_persisted
    end

    it 'normalises clinic title' do
      expect(operation['model'].title).to eq 'Outpatient Haematology Clinic'
    end
  end
end
