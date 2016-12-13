require_dependency 'employee/operation/show'

class Nurse::Show < ::Employee::Show
  model  Nurse, :find
  policy NursePolicy, :show?

  representer V1::NurseRepresenter
end
