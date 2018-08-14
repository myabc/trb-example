class Ward::Bookmark < Trailblazer::Operation
  step Model(Ward, :find)
  step Policy::Pundit(WardPolicy, :bookmark?)
  step :process

  def process(_options, model:, current_user:, **)
    model.bookmarks.for(current_user).first_or_create
  end
end
