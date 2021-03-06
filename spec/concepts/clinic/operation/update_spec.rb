require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Clinic::Update, type: :operation do
  include_context 'with an existing clinic'

  context 'with invalid params' do
    subject(:operation) { Clinic::Update.run(params)[1] }

    let(:params) {
      {
        clinic:       { title: '' },
        id:           clinic.id,
        current_user: patient_author
      }.with_indifferent_access
    }

    it 'does not update the clinic' do
      expect(operation.contract.errors.messages)
        .to eq(title: ['must be filled', 'size cannot be greater than 50'])
    end
  end

  context 'with valid params' do
    subject(:operation) { Clinic::Update.call(params) }

    let(:params) {
      {
        clinic:       { title: "Dr Johnson's Andrology clinic\n" },
        id:           clinic.id,
        current_user: patient_author
      }.with_indifferent_access
    }

    it 'updates the clinic' do
      expect(operation.model.title).to eq "Dr Johnson's Andrology clinic"
    end
  end
end
