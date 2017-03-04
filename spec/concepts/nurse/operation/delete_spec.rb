require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Delete, type: :operation do
  include_context 'with an existing current nurse'

  subject(:operation) {
    Nurse::Delete.call({ id: nurse.id }, 'current_user' => patient_author)
  }

  it 'deletes the nurse' do
    expect { operation['model'].reload }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
