require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Unbookmark, type: :operation do
  include_context 'with an existing ward'
  subject(:operation) {
    Ward::Unbookmark.call(id: ward.id, current_user: patient)
  }

  shared_examples_for 'unbookmarking the ward' do
    it 'unbookmarks the ward' do
      expect(operation.model.bookmarks.for(patient).exists?).to be false
    end
  end

  context 'when the ward is bookmarked' do
    before do
      Ward::Bookmark.call(id: ward.id, current_user: patient)
    end

    it_behaves_like 'unbookmarking the ward'
  end

  context 'when the ward is not bookmarked' do
    it_behaves_like 'unbookmarking the ward'
  end
end
