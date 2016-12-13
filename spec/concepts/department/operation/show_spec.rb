require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Department::Show, type: :operation do
  include_context 'with an existing department'

  subject(:operation) {
    Department::Show.call(id: department.id, current_user: patient_creator)
  }

  it 'shows the department' do
    expect(operation.model).to eq department
  end
end
