module Commenting
  module Commentable
    extend ActiveSupport::Concern

    included do
      has_many :threads, as: :subject, class_name: 'Commenting::Thread', dependent: :destroy
      has_many :comments, through: :threads
    end
  end
end
