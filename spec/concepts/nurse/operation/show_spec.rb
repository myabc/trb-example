require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Show, type: :operation do
  include_context 'with an existing former nurse'

  subject(:operation) {
    Nurse::Show.call({ id: nurse.id }, 'current_user' => patient_author)
  }

  it 'shows the nurse' do
    expect(operation['model']).to eq nurse
  end
end
