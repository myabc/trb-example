require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Department::Create, type: :operation do
  let(:patient_creator) { create(:patient) }
  let(:hospital) { create(:hospital) }

  context 'with invalid params' do
    subject(:operation) { Department::Create.call(params, 'current_user' => patient_creator) }

    context 'when params are missing' do
      let(:params) {
        {
          department:   { title: '' },
          hospital_id:  hospital.id
        }.with_indifferent_access
      }

      it 'does not create the department' do
        expect(operation['model']).not_to be_persisted
        expect(operation['result.contract.default'].errors.messages)
          .to eq(title: [
                   'must be filled',
                   'size cannot be greater than 65'
                 ])
      end

      it 'does not create nested clinics' do
        expect(operation['model'].clinics).to be_empty
      end
    end

    context 'when params are invalid' do
      let(:params) {
        {
          department: {
            title:    ('1' * 66).to_s,
            clinics: [
              { title: '1. Not a clinic' },
              { title: '2. Watch out!' },
              { title: 'Volare, oh oh E contare, oh Nel blu, dipinto di blu' }
            ]
          },
          hospital_id:  hospital.id
        }.with_indifferent_access
      }

      it 'does not create the department' do
        expect(operation['model']).not_to be_persisted
        expect(operation['result.contract.default'].errors.messages)
          .to eq(title:    ['size cannot be greater than 65'],
                 'clinics.title': [
                   'size cannot be greater than 50'
                 ])
      end

      it 'does not create nested clinics' do
        expect(operation['model'].clinics.size).to eq 3
        expect(operation['model'].clinics).to all be_new_record
      end
    end
  end

  context 'with valid params' do
    subject(:operation) { Department::Create.call(params, 'current_user' => patient_creator) }

    let(:params) {
      {
        department: {
          title:    "\nVascular Services"
        },
        hospital_id:  hospital.id
      }.with_indifferent_access
    }

    it 'creates the department' do
      expect(operation['model']).to be_persisted
      expect(operation['model']).to have_attributes(creator: patient_creator)
    end

    it 'does not create nested clinics' do
      expect(operation['model'].clinics).to be_empty
    end

    it 'normalises department title' do
      expect(operation['model'].title).to eq 'Vascular Services'
    end
  end

  context 'with valid nested params' do
    subject(:operation) { Department::Create.call(params, 'current_user' => patient_creator) }

    let(:params) {
      {
        department: {
          title:    "\nVascular Services",
          clinics: [
            { title: "\nYour First Clinic" },
            { title: '  Your Final Clinic' }
          ]
        },
        hospital_id:  hospital.id
      }.with_indifferent_access
    }

    it 'creates the department' do
      expect(operation['model']).to be_persisted
      expect(operation['model']).to have_attributes(creator: patient_creator)
    end

    it 'creates nested clinics' do
      expect(operation['model'].clinics.size).to eq 2
      expect(operation['model'].clinics).to all be_persisted
      expect(operation['model'].clinics).to all have_attributes(author: patient_creator)
    end

    it 'normalises department and clinic titles' do
      expect(operation['model'].title).to eq 'Vascular Services'
      expect(operation['model'].clinics.map(&:title))
        .to eq ['Your First Clinic', 'Your Final Clinic']
    end
  end
end
