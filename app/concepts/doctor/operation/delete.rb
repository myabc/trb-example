require_dependency 'employee/operation/delete'

class Doctor::Delete < ::Employee::Delete
  model  Doctor, :find
  policy DoctorPolicy, :destroy?
end
