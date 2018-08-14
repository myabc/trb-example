class Commenting::Comment::Report < Trailblazer::Operation
  step Model(Commenting::Comment, :find)
  step Policy::Pundit(Commenting::CommentPolicy, :report?)
  step :process

  def process(_options, model:, **)
    model.reported!

    # notify_author if status_changed_to == 'reported'
  end

  private

  def notify_author; end

  def status_changed_to
    model.previous_changes.fetch('status', []).last
  end
end
