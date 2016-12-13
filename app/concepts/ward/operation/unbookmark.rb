class Ward::Unbookmark < Trailblazer::Operation
  include Model
  include Policy
  model Ward, :find
  policy WardPolicy, :unbookmark?

  def process(params)
    model.bookmarks.for(params.fetch(:current_user)).destroy_all
  end
end
