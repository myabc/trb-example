module Commenting
  class Thread < ActiveRecord::Base
    belongs_to :subject, polymorphic: true

    has_many :comments, class_name: 'Commenting::Comment', dependent: :destroy
  end
end
