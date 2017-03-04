class Commenting::Comment::Delete < Trailblazer::Operation
  step Model(Commenting::Comment, :find)
  step Policy::Pundit(Commenting::CommentPolicy, :destroy?)
  step :process

  def process(_options, model:, **)
    model.destroy
  end
end
