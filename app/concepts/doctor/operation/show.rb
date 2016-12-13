require_dependency 'employee/operation/show'

class Doctor::Show < ::Employee::Show
  model  Doctor, :find
  policy DoctorPolicy, :show?

  representer V1::DoctorRepresenter
end
