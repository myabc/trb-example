class Clinic::Update < Trailblazer::Operation
  step Model(Clinic, :update)
  step Policy::Pundit(ClinicPolicy, :update?)
  step Contract::Build(constant: Clinic::Contract::Update)
  step Contract::Validate(key: 'clinic')
  step Contract::Persist()

  extend Representer::DSL
  representer :serializer, V1::ClinicRepresenter
end
