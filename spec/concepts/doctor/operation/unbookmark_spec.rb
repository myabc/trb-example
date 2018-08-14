require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Unbookmark, type: :operation do
  include_context 'with an existing current doctor'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Doctor::Unbookmark.call({ id: doctor.id }, 'current_user' => patient)
  }

  shared_examples_for 'unbookmarking the doctor' do
    it 'unbookmarks the doctor' do
      expect(operation['model'].bookmarks.for(patient).exists?).to be false
    end
  end

  context 'when the doctor is bookmarked' do
    before do
      Doctor::Bookmark.call({ id: doctor.id }, 'current_user' => patient)
    end

    it_behaves_like 'unbookmarking the doctor'
  end

  context 'when the doctor is not bookmarked' do
    it_behaves_like 'unbookmarking the doctor'
  end
end
