require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Nurse::Unbookmark, type: :operation do
  include_context 'with an existing current nurse'

  let(:patient) { create(:patient) }
  subject(:operation) {
    Nurse::Unbookmark.call(id: nurse.id, current_user: patient)
  }

  shared_examples_for 'unbookmarking the nurse' do
    it 'unbookmarks the nurse' do
      expect(operation.model.bookmarks.for(patient).exists?).to be false
    end
  end

  context 'when the nurse is bookmarked' do
    before do
      Nurse::Bookmark.call(id: nurse.id, current_user: patient)
    end

    it_behaves_like 'unbookmarking the nurse'
  end

  context 'when the nurse is not bookmarked' do
    it_behaves_like 'unbookmarking the nurse'
  end
end
