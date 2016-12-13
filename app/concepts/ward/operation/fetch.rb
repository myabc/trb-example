class Ward::Fetch < Trailblazer::Operation
  include Model
  include Policy
  model  Ward,       :find
  policy WardPolicy, :show?

  def process(_params); end
end
