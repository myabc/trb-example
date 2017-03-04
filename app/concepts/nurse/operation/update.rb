require_dependency 'employee/operation/update'

class Nurse::Update < ::Employee::Update
  step Model(Nurse, :update)
  step Policy::Pundit(NursePolicy, :update?)
  step Nested(:build!)

  def build!(options, **)
    return self.class::Privileged if options['policy.default'].user_is_privileged?
    self.class::Default
  end

  class Default < Trailblazer::Operation
    step Model(Nurse, :update)
    step Policy::Pundit(NursePolicy, :update?)
    step Contract::Build()
    step Contract::Validate(key: 'nurse')
    step Contract::Persist()

    extend Contract::DSL
    extend Representer::DSL

    representer :serializer, V1::NurseRepresenter

    contract Nurse::Contract::Update
  end

  class Privileged < Default
    representer :serializer, V1::NurseRepresenter do
      include V1::NurseRepresenter::UpdatePrivileged
    end

    contract Nurse::Contract::Update do
      include Employee::Contract::UpdatePrivileged
    end
  end
end
