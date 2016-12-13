require_dependency 'employee/operation/create'

class Doctor::Create < ::Employee::Create
  include Resolver

  model  Doctor, :create
  policy DoctorPolicy, :create?

  builds ->(_model, policy, _params) do
    return self::Privileged if policy.user_is_privileged?
    self::Default
  end

  def self.model!(params)
    find_clinic(params).doctors.new
  end

  class Default < self
    representer V1::DoctorRepresenter

    contract Doctor::Contract::Create
  end

  class Privileged < Default
    representer V1::DoctorRepresenter do
      include V1::DoctorRepresenter::CreatePrivileged
    end

    contract Doctor::Contract::Create do
      include Employee::Contract::CreatePrivileged
    end
  end
end
