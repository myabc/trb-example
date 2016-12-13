require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Index, type: :operation do
  include_context 'with an existing current nurse'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Nurse::Index.call(clinic_id: clinic.id, current_user: patient)
  }

  it 'shows the nurse' do
    expect(operation.model).to include nurse
  end
end
