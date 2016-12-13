require_dependency 'employee/operation/unbookmark'

class Nurse::Unbookmark < ::Employee::Unbookmark
  model  Nurse, :find
  policy NursePolicy, :unbookmark?
end
