require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Department::Index, type: :operation do
  include JsonSpec::Helpers

  include_context 'with an existing department'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Department::Index.call({ hospital_id: hospital.id }, 'current_user' => patient)
  }

  it 'shows the department' do
    expect(operation['model']).to all be_a(Department)
    expect(operation['model'].first).to eq department
  end

  it 'renders JSON' do
    expect(operation.to_json).to have_json_path('departments')
    expect(operation.to_json).to have_json_path('departments/0/id')
  end
end
