require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Delete, type: :operation do
  include_context 'with an existing current doctor'

  subject(:operation) {
    Doctor::Delete.call(id: doctor.id, current_user: patient_author)
  }

  it 'deletes the doctor' do
    expect { operation.model.reload }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
