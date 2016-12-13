require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Show, type: :operation do
  include_context 'with an existing former doctor'

  subject(:operation) {
    Doctor::Show.call(id: doctor.id, current_user: patient_author)
  }

  it 'shows the doctor' do
    expect(operation.model).to eq doctor
  end
end
