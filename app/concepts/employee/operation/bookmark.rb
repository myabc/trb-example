class Employee::Bookmark < Trailblazer::Operation
  include Model
  include Policy

  def process(params)
    model.bookmarks.for(params.fetch(:current_user)).first_or_create
  end
end
