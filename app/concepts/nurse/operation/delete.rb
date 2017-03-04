require_dependency 'employee/operation/delete'

class Nurse::Delete < ::Employee::Delete
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :destroy?)
  step :process
end
