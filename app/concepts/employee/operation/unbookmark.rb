class Employee::Unbookmark < Trailblazer::Operation
  include Model
  include Policy

  def process(params)
    model.bookmarks.for(params.fetch(:current_user)).destroy_all
  end
end
