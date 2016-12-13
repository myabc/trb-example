class Department < ActiveRecord::Base
  extend FriendlyId
  include Commenting::Commentable

  friendly_id :acronym_and_title, use: :slugged

  has_many :clinics, dependent: :destroy
  has_many :nurses,  through: :clinics
  has_many :doctors, through: :clinics
  has_many :wards

  belongs_to :creator, class_name: 'User'
  belongs_to :hospital

  private

  def acronym_and_title
    "#{hospital.acronym} - #{title}"
  end
end
