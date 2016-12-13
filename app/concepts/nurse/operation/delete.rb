require_dependency 'employee/operation/delete'

class Nurse::Delete < ::Employee::Delete
  model  Nurse, :find
  policy NursePolicy, :destroy?
end
