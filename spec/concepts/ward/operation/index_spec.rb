require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Index, type: :operation do
  include JsonSpec::Helpers

  include_context 'with an existing ward'

  let(:user) { create(:patient) }
  subject(:operation) {
    Ward::Index.call(department_id:  department.id,
                     current_user: user)
  }

  it 'shows the ward' do
    expect(operation.model).to all be_a(Ward)
    expect(operation.model.first).to eq ward
  end

  it 'renders JSON' do
    expect(operation.to_json).to have_json_path('wards')
    expect(operation.to_json).to have_json_path('wards/0/id')
  end
end
