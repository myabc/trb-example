class Employee::Unbookmark < Trailblazer::Operation
  def process(_options, model:, current_user:, **)
    model.bookmarks.for(current_user).destroy_all
  end
end
