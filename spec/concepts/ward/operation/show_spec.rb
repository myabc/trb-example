require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Show, type: :operation do
  include_context 'with an existing ward'

  subject(:operation) {
    Ward::Show.call({ id: ward.id }, 'current_user' => patient)
  }

  it 'shows the ward' do
    expect(operation['model']).to eq ward
  end
end
