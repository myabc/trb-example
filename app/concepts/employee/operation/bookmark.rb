class Employee::Bookmark < Trailblazer::Operation
  def process(_options, model:, current_user:, **)
    model.bookmarks.for(current_user).first_or_create
  end
end
