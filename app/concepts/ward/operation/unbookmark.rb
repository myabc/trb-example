class Ward::Unbookmark < Trailblazer::Operation
  step Model(Ward, :find)
  step Policy::Pundit(WardPolicy, :unbookmark?)
  step :process

  def process(_options, model:, current_user:, **)
    model.bookmarks.for(current_user).destroy_all
  end
end
