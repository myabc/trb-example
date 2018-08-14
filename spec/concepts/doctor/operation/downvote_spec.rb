require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Downvote, type: :operation do
  include_context 'with an existing current doctor'

  let(:patient_voter) { create(:patient) }
  subject(:operation) {
    Doctor::Downvote.call({ id: doctor.id }, 'current_user' => patient_voter)
  }

  shared_examples_for 'downvoting the doctor' do
    it 'downvotes the doctor' do
      user_doctor_votes = operation['model'].votes.for(patient_voter)

      expect(user_doctor_votes.down.count).to eq 1
      expect(user_doctor_votes.up.count).to eq 0
    end
  end

  context 'when the user has not voted' do
    it_behaves_like 'downvoting the doctor'
  end

  context 'when the user has already downvoted' do
    before do
      Doctor::Downvote.call({ id: doctor.id }, 'current_user' => patient_voter)
    end

    it_behaves_like 'downvoting the doctor'
  end

  context 'when the user has already upvoted' do
    before do
      Doctor::Upvote.call({ id: doctor.id }, 'current_user' => patient_voter)
    end

    it_behaves_like 'downvoting the doctor'
  end
end
