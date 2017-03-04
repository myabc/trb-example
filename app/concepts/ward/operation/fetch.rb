class Ward::Fetch < Trailblazer::Operation
  step Model(Ward, :find)
  step Policy::Pundit(WardPolicy, :show?)
end
