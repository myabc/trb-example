require_dependency 'employee/operation/update'

class Doctor::Update < ::Employee::Update
  step Model(Doctor, :update)
  step Policy::Pundit(DoctorPolicy, :update?)
  step Nested(:build!)

  def build!(options, **)
    return self.class::Privileged if options['policy.default'].user_is_privileged?
    self.class::Default
  end

  class Default < Trailblazer::Operation
    step Model(Doctor, :update)
    step Policy::Pundit(DoctorPolicy, :update?)
    step Contract::Build()
    step Contract::Validate(key: 'doctor')
    step Contract::Persist()
    extend Contract::DSL
    extend Representer::DSL

    representer :render, V1::DoctorRepresenter

    contract Doctor::Contract::Update
  end

  class Privileged < Default
    representer :render, V1::DoctorRepresenter do
      include V1::DoctorRepresenter::UpdatePrivileged
    end

    contract Doctor::Contract::Update do
      include Employee::Contract::UpdatePrivileged
    end
  end
end
