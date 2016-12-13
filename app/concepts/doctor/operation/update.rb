require_dependency 'employee/operation/update'

class Doctor::Update < ::Employee::Update
  include Resolver

  model  Doctor, :update
  policy DoctorPolicy, :update?

  self.builder_class = Doctor::Create.builder_class

  class Default < self
    representer V1::DoctorRepresenter

    contract Doctor::Contract::Update
  end

  class Privileged < Default
    representer V1::DoctorRepresenter do
      include V1::DoctorRepresenter::UpdatePrivileged
    end

    contract Doctor::Contract::Update do
      include Employee::Contract::UpdatePrivileged
    end
  end
end
