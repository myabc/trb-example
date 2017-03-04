require_dependency 'employee/operation/create'

class Nurse::Create < ::Employee::Create
  step :model!
  step Policy::Pundit(NursePolicy, :create?)
  # step Nested(:build!)
  step Contract::Build(constant: Nurse::Contract::Create)
  step :assign_author
  step Contract::Validate(key: 'nurse')
  step Contract::Persist()

  def build!(options, **)
    return self.class::Privileged if options['policy.default'].user_is_privileged?
    self.class::Default
  end

  def model!(options, params:, **)
    options['model'] = find_clinic(params).nurses.new
  end

  class Default < Trailblazer::Operation
    extend Contract::DSL
    extend Representer::DSL

    representer :serializer, V1::NurseRepresenter

    contract Nurse::Contract::Create
  end

  class Privileged < Default
    representer :serializer, V1::NurseRepresenter do
      include V1::NurseRepresenter::CreatePrivileged
    end

    contract Nurse::Contract::Create do
      include Employee::Contract::CreatePrivileged
    end
  end
end
