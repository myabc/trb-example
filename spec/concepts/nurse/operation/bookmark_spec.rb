require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Bookmark, type: :operation do
  include_context 'with an existing current nurse'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Nurse::Bookmark.call({ id: nurse.id }, 'current_user' => patient)
  }

  shared_examples_for 'bookmarking the nurse' do
    it 'bookmarks the nurse' do
      expect(operation['model'].bookmarks.for(patient).exists?).to be true
    end
  end

  context 'when the nurse is not bookmarked' do
    it_behaves_like 'bookmarking the nurse'
  end

  context 'when the nurse is already bookmarked' do
    before do
      Nurse::Bookmark.call({ id: nurse.id }, 'current_user' => patient)
    end

    it_behaves_like 'bookmarking the nurse'
  end
end
