class Employee::Upvote < Trailblazer::Operation
  attr_accessor :vote

  def process(_options, model:, current_user:, **)
    Vote.transaction do
      self.vote = model.votes.for(current_user)
                       .first_or_initialize
      vote.direction = 'up'
      vote.save!
    end

    notify_author if vote_direction_changed_to == 'up'
  end

  private

  def notify_author; end

  def vote_direction_changed_to
    vote.previous_changes.fetch('direction', []).last
  end
end
