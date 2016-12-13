module Bookmarkable
  extend ActiveSupport::Concern

  included do
    has_many :bookmarks, as: :bookmarkable, class_name: '::Bookmark',
                         dependent: :destroy
  end
end
