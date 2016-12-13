require_dependency 'employee/operation/update'

class Nurse::Update < ::Employee::Update
  include Resolver

  model  Nurse, :update
  policy NursePolicy, :update?

  self.builder_class = Nurse::Create.builder_class

  class Default < self
    representer V1::NurseRepresenter

    contract Nurse::Contract::Update
  end

  class Privileged < Default
    representer V1::NurseRepresenter do
      include V1::NurseRepresenter::UpdatePrivileged
    end

    contract Nurse::Contract::Update do
      include Employee::Contract::UpdatePrivileged
    end
  end
end
