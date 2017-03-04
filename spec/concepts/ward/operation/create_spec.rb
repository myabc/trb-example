require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Create, type: :operation do
  let(:admin) { create(:admin) }
  let(:patient) { create(:patient) }
  let(:department) { create(:department) }

  context 'with invalid params' do
    subject(:operation) { Ward::Create.call(params, 'current_user' => patient) }

    context 'when params are missing' do
      let(:params) {
        {
          ward:         { name: '' },
          department_id:    department.id
        }.with_indifferent_access
      }

      it 'does not create the ward' do
        expect(operation['model']).not_to be_persisted
        expect(operation['result.contract.default'].errors.messages)
          .to eq(category: ['must be filled',
                            'must be one of: intensive, non_intensive'],
                 url: ['must be filled',
                       'must be a valid URL'],
                 description: ['must be filled', 'size cannot be greater than 500'],
                 name: ['must be filled'])
      end
    end

    context 'when params are invalid' do
      let(:params) {
        {
          ward: {
            name:         'Albert Ward',
            description:  ('x' * 501).to_s,
            category:     'non-existent',
            url:          'ftp://guysandstthomas.nhs.uk/our-services/wards/ward-list.aspx',
            emergency:    'Guy Fawkes'
          },
          department_id:    department.id
        }.with_indifferent_access
      }

      it 'does not create the ward' do
        expect(operation['model']).not_to be_persisted
        expect(operation['result.contract.default'].errors.messages)
          .to eq(category:    ['must be one of: intensive, non_intensive'],
                 description: ['size cannot be greater than 500'],
                 url:         ['must be a valid URL'],
                 emergency:   ['must be boolean'])
      end
    end
  end

  context 'with valid params' do
    subject(:operation) { Ward::Create.call(params, 'current_user' => patient) }

    let(:params) {
      {
        ward:    {
          name:         'Antenatal Ward',
          description:  " Highly-specialised\r\n",
          category:     'non_intensive',
          url:          'http://guysandstthomas.nhs.uk/our-services/wards/ward-list.aspx',
          emergency:    't'
        },
        department_id:   department.id
      }.with_indifferent_access
    }

    it 'creates the ward' do
      expect(operation['model']).to be_persisted
    end

    it 'normalises ward description' do
      expect(operation['model'].description).to eq 'Highly-specialised'
    end
  end
end
