class Ward::Bookmark < Trailblazer::Operation
  include Model
  include Policy
  model  Ward, :find
  policy WardPolicy, :bookmark?

  def process(params)
    model.bookmarks.for(params.fetch(:current_user)).first_or_create
  end
end
