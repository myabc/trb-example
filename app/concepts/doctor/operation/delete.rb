require_dependency 'employee/operation/delete'

class Doctor::Delete < ::Employee::Delete
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :destroy?)
  step :process
end
