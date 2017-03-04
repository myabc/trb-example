require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Downvote, type: :operation do
  include_context 'with an existing current nurse'

  let(:patient_voter) { create(:patient) }
  subject(:operation) {
    Nurse::Downvote.call({ id: nurse.id }, 'current_user' => patient_voter)
  }

  shared_examples_for 'downvoting the nurse' do
    it 'downvotes the nurse' do
      user_nurse_votes = operation['model'].votes.for(patient_voter)

      expect(user_nurse_votes.down.count).to eq 1
      expect(user_nurse_votes.up.count).to eq 0
    end
  end

  context 'when the user has not voted' do
    it_behaves_like 'downvoting the nurse'
  end

  context 'when the user has already downvoted' do
    before do
      Nurse::Downvote.call({ id: nurse.id }, 'current_user' => patient_voter)
    end

    it_behaves_like 'downvoting the nurse'
  end

  context 'when the user has already upvoted' do
    before do
      Nurse::Upvote.call({ id: nurse.id }, 'current_user' => patient_voter)
    end

    it_behaves_like 'downvoting the nurse'
  end
end
