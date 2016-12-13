class Ward::Delete < Trailblazer::Operation
  include Model
  include Policy
  model  Ward,       :find
  policy WardPolicy, :destroy?

  def process(_params)
    ward = model.destroy!
  end
end
