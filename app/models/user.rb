class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :hospital

  has_many :bookmarks, dependent: :destroy
  has_many :votes
end
