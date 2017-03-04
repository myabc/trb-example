class Clinic::Show < Trailblazer::Operation
  step Model(Clinic, :find)
  step Policy::Pundit(ClinicPolicy, :show?)

  extend Representer::DSL
  representer :serializer, V1::ClinicRepresenter
end
