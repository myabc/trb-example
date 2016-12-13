require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Clinic::Delete, type: :operation do
  include_context 'with an existing clinic'

  subject(:operation) {
    Clinic::Delete.call(id: clinic.id, current_user: patient_author)
  }

  it 'deletes the clinic' do
    expect { operation.model.reload }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
