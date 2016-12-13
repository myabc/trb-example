class Commenting::Comment::Report < Trailblazer::Operation
  include Model
  include Policy
  model  Commenting::Comment, :find
  policy Commenting::CommentPolicy, :report?

  def process(_params)
    model.reported!

    notify_author if status_changed_to == 'reported'
  end

  private

  def notify_author; end

  def status_changed_to
    model.previous_changes.fetch('status', []).last
  end
end
