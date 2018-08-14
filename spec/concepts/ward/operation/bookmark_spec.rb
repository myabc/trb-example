require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Ward::Bookmark, type: :operation do
  include_context 'with an existing ward'
  subject(:operation) {
    Ward::Bookmark.call({ id: ward.id }, 'current_user' => patient)
  }

  shared_examples_for 'bookmarking the ward' do
    it 'bookmarks the ward' do
      expect(operation['model'].bookmarks.for(patient).exists?).to be true
    end
  end

  context 'when the ward is not bookmarked' do
    it_behaves_like 'bookmarking the ward'
  end

  context 'when the ward is already bookmarked' do
    before do
      Ward::Bookmark.call({ id: ward.id }, 'current_user' => patient)
    end

    it_behaves_like 'bookmarking the ward'
  end
end
