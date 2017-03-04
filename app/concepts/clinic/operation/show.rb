class Clinic::Show < Trailblazer::Operation
  step Model(Clinic, :find)
  step Policy::Pundit(ClinicPolicy, :show?)

  extend Representer::DSL
  representer :render, V1::ClinicRepresenter
end
