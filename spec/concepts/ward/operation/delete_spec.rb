require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Delete, type: :operation do
  include_context 'with an existing ward'

  subject(:operation) {
    Ward::Delete.call({ id: ward.id }, 'current_user' => patient)
  }

  it 'deletes the ward record' do
    expect { operation['model'].reload }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
