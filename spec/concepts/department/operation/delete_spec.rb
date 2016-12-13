require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Department::Delete, type: :operation do
  include_context 'with an existing department'

  subject(:operation) {
    Department::Delete.call(id: department.id, current_user: patient_creator)
  }

  it 'deletes the department' do
    expect { operation.model.reload }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
