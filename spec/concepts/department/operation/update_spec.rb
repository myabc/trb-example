require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Department::Update, type: :operation do
  include_context 'with an existing department'

  context 'with invalid params' do
    subject(:operation) { Department::Update.run(params)[1] }

    let(:params) {
      {
        department:   { title: '' },
        id:           department.id,
        current_user: patient_creator
      }.with_indifferent_access
    }

    it 'does not update the department' do
      expect(operation.contract.errors.messages)
        .to eq(title: [
                 'must be filled',
                 'size cannot be greater than 65'
               ])
    end
  end

  context 'with valid params' do
    subject(:operation) { Department::Update.call(params) }

    let(:params) {
      {
        department:   { title: "Aeronautical Engineering 401\n" },
        id:           department.id,
        current_user: patient_creator
      }.with_indifferent_access
    }

    it 'updates the department' do
      expect(operation.model.title).to eq 'Aeronautical Engineering 401'
    end
  end
end
