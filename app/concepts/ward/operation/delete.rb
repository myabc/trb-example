class Ward::Delete < Trailblazer::Operation
  step Model(Ward, :find)
  step Policy::Pundit(WardPolicy, :destroy?)
  step :process

  def process(_options, model:, **)
    model.destroy!
  end
end
