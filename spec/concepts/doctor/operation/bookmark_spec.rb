require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Bookmark, type: :operation do
  include_context 'with an existing current doctor'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Doctor::Bookmark.call({ id: doctor.id }, 'current_user' => patient)
  }

  shared_examples_for 'bookmarking the doctor' do
    it 'bookmarks the doctor' do
      expect(operation['model'].bookmarks.for(patient).exists?).to be true
    end
  end

  context 'when the doctor is not bookmarked' do
    it_behaves_like 'bookmarking the doctor'
  end

  context 'when the doctor is already bookmarked' do
    before do
      Doctor::Bookmark.call({ id: doctor.id }, 'current_user' => patient)
    end

    it_behaves_like 'bookmarking the doctor'
  end
end
