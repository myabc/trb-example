require_dependency 'employee/operation/unbookmark'

class Nurse::Unbookmark < ::Employee::Unbookmark
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :unbookmark?)
  step :process
end
