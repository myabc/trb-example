module Curatable
  extend ActiveSupport::Concern

  included do
    enum status: {
      published:           'published',
      draft:               'draft',
      reported:            'reported',
      marked_for_deletion: 'marked_for_deletion'
    }

    scope :unpublished,
          -> { where.not(status: :published) }
    scope :not_marked_for_deletion,
          -> { where.not(status: :marked_for_deletion) }

    alias_method :published, :published?
    alias_method :reported, :reported?
  end

  def unpublished?
    !published?
  end
end
