class Ward::Upvote < Trailblazer::Operation
  step Model(Ward, :find)
  step Policy::Pundit(WardPolicy, :show?)
  step :process

  attr_accessor :vote

  def process(_options, model:, current_user:, **)
    Vote.transaction do
      self.vote = model.votes.for(current_user)
                       .first_or_initialize
      vote.direction = 'up'
      vote.save!
    end

    notify_creator if vote_type_changed_to == 'up'
  end

  private

  def notify_creator; end

  def vote_type_changed_to
    vote.previous_changes.fetch('type', []).last
  end
end
