require_dependency 'employee/operation/create'

class Doctor::Create < ::Employee::Create
  step :model!
  step Policy::Pundit(DoctorPolicy, :create?)
  # step Nested(:build!)
  step Contract::Build(constant: Doctor::Contract::Create)
  step :assign_author
  step Contract::Validate(key: 'doctor')
  step Contract::Persist()

  def build!(options, **)
    return self.class::Privileged if options['policy.default'].user_is_privileged?
    self.class::Default
  end

  def model!(options, params:, **)
    options['model'] = find_clinic(params).doctors.new
  end

  class Default < Trailblazer::Operation
    extend Contract::DSL
    extend Representer::DSL

    representer :serializer, V1::DoctorRepresenter

    contract Doctor::Contract::Create
  end

  class Privileged < Default
    representer :serializer, V1::DoctorRepresenter do
      include V1::DoctorRepresenter::CreatePrivileged
    end

    contract Doctor::Contract::Create do
      include Employee::Contract::CreatePrivileged
    end
  end
end
