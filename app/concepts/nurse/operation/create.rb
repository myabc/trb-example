require_dependency 'employee/operation/create'

class Nurse::Create < ::Employee::Create
  include Resolver

  model  Nurse, :create
  policy NursePolicy, :create?

  builds ->(_model, policy, _params) do
    return self::Privileged if policy.user_is_privileged?
    self::Default
  end

  def self.model!(params)
    find_clinic(params).nurses.new
  end

  class Default < self
    representer V1::NurseRepresenter

    contract Nurse::Contract::Create
  end

  class Privileged < Default
    representer V1::NurseRepresenter do
      include V1::NurseRepresenter::CreatePrivileged
    end

    contract Nurse::Contract::Create do
      include Employee::Contract::CreatePrivileged
    end
  end
end
