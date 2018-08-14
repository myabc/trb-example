require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Clinic::Index, type: :operation do
  include JsonSpec::Helpers

  include_context 'with an existing clinic'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Clinic::Index.call({ department_id: department.id }, 'current_user' => patient)
  }

  it 'shows the clinic' do
    expect(operation['model']).to all be_a(Clinic)
    expect(operation['model'].first).to eq clinic
  end

  it 'renders JSON' do
    json = operation['representer.render.class'].new(operation['model']).to_json

    expect(json).to have_json_path('clinics')
    expect(json).to have_json_path('clinics/0/id')
  end
end
