class Employee::Downvote < Trailblazer::Operation
  include Model
  include Policy

  attr_accessor :vote

  def process(params)
    Vote.transaction do
      self.vote = model.votes.for(params.fetch(:current_user))
                       .first_or_initialize
      vote.direction = 'down'
      vote.save!
    end

    notify_author if vote_type_changed_to == 'down'
  end

  private

  def notify_author; end

  def vote_type_changed_to
    vote.previous_changes.fetch('type', []).last
  end
end
