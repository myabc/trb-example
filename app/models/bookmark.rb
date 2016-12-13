class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  def self.for(user)
    where(user: user)
  end
end
