require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Clinic::Show, type: :operation do
  include_context 'with an existing clinic'

  subject(:operation) {
    Clinic::Show.call({ id: clinic.id }, 'current_user' => patient_author)
  }

  it 'shows the clinic' do
    expect(operation['model']).to eq clinic
  end
end
