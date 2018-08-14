class Clinic::Show < Trailblazer::Operation
  step Model(Clinic, :find)
  step Policy::Pundit(ClinicPolicy, :show?)
  step ->(options) { options['present'] = true }

  extend Representer::DSL
  representer :serializer, V1::ClinicRepresenter
end
