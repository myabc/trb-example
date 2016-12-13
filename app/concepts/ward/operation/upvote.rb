class Ward::Upvote < Trailblazer::Operation
  include Model
  include Policy
  model Ward, :find
  policy WardPolicy, :show?

  attr_accessor :vote

  def process(params)
    Vote.transaction do
      self.vote = model.votes.for(params.fetch(:current_user))
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
