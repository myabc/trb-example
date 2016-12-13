require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Upvote, type: :operation do
  include_context 'with an existing ward'

  let(:patient_voter)   { create(:patient) }
  subject(:operation) {
    Ward::Upvote.call(id: ward.id, current_user: patient_voter)
  }

  shared_examples_for 'upvoting the ward' do
    it 'upvotes the ward' do
      user_ward_votes = operation.model.votes.for(patient_voter)

      expect(user_ward_votes.up.count).to eq 1
    end
  end

  context 'when the user has not voted' do
    it_behaves_like 'upvoting the ward'
  end

  context 'when the user has already upvoted' do
    before do
      Ward::Upvote.call(id: ward.id, current_user: patient_voter)
    end

    it_behaves_like 'upvoting the ward'
  end
end
