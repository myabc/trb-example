class Ward < ActiveRecord::Base
  include Curatable
  include Votable
  include Bookmarkable

  CATEGORIES = %w(intensive non_intensive).freeze

  belongs_to :creator, class_name: 'User'
  belongs_to :department

  enum category: CATEGORIES.reduce({}) { |result, category|
    result.merge!(category.to_sym => category)
  }
end
