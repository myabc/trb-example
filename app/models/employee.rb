class Employee < ActiveRecord::Base
  include Commenting::Commentable
  include Votable
  include Bookmarkable

  belongs_to :clinic
  belongs_to :author, class_name: 'User'
  has_one :department, through: :clinic

  enum status: {
    current:  'current',
    former:   'former',
    reported: 'reported'
  }

  # alias_method :current, :published?
  # alias_method :reported, :reported?
end
