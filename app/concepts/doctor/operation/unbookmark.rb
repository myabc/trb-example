require_dependency 'employee/operation/unbookmark'

class Doctor::Unbookmark < ::Employee::Unbookmark
  model  Doctor, :find
  policy DoctorPolicy, :unbookmark?
end
