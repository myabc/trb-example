class Clinic < ActiveRecord::Base
  include Commenting::Commentable

  belongs_to :department
  belongs_to :author, class_name: 'User'

  has_many :doctors
  has_many :nurses
end
