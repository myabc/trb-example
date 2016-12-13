class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  after_save :update_counters

  def self.up
    where(direction: 'up')
  end

  def self.down
    where(direction: 'down')
  end

  def self.for(user)
    where(user: user)
  end

  private

  def update_counters
    if direction_changed? && !id_changed?
      votable_type.constantize.increment_counter "#{direction}_votes_count", votable_id
      votable_type.constantize.decrement_counter "#{direction}_votes_count", votable_id
    end
  end
end
