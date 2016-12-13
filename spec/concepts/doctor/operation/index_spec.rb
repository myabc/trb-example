require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Index, type: :operation do
  include_context 'with an existing current doctor'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Doctor::Index.call(clinic_id: clinic.id, current_user: patient)
  }

  it 'shows the doctor' do
    expect(operation.model).to include doctor
  end
end
