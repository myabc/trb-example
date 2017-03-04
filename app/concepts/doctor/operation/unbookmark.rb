require_dependency 'employee/operation/unbookmark'

class Doctor::Unbookmark < ::Employee::Unbookmark
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :unbookmark?)
  step :process
end
