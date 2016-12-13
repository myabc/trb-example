class Commenting::Comment::Delete < Trailblazer::Operation
  include Model
  include Policy
  model  Commenting::Comment, :find
  policy Commenting::CommentPolicy, :destroy?

  def process(_params)
    model.destroy
  end
end
