class User < ActiveRecord::Base
  belongs_to :hospital

  has_many :bookmarks, dependent: :destroy
  has_many :votes
end
